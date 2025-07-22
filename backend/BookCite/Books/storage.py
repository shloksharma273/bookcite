import os
import io
import mimetypes
import pickle

from django.core.files.storage import Storage
from django.conf import settings
from google.auth.transport.requests import Request
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.discovery import build
from googleapiclient.http import MediaIoBaseUpload, MediaIoBaseDownload


class GoogleDriveStorage(Storage):
    SCOPES = ['https://www.googleapis.com/auth/drive.file']

    def __init__(self):
        self.credentials_file = getattr(settings, 'GOOGLE_DRIVE_CREDENTIALS_FILE', 'client_secrets.json')
        self.token_file = getattr(settings, 'GOOGLE_DRIVE_TOKEN_FILE', 'token.pickle')
        self.folder_id = getattr(settings, 'GOOGLE_DRIVE_ROOT_FOLDER_ID', None)

        self.service = self._authenticate()

    def _authenticate(self):
        creds = None

        if os.path.exists(self.token_file):
            with open(self.token_file, 'rb') as token:
                creds = pickle.load(token)

        if not creds or not creds.valid:
            if creds and creds.expired and creds.refresh_token:
                creds.refresh(Request())
            else:
                flow = InstalledAppFlow.from_client_secrets_file(self.credentials_file, self.SCOPES)
                creds = flow.run_local_server(port=8081)

            with open(self.token_file, 'wb') as token:
                pickle.dump(creds, token)

        return build('drive', 'v3', credentials=creds)

    def _get_mimetype(self, name):
        mimetype, _ = mimetypes.guess_type(name)
        return mimetype or 'application/octet-stream'

    def _get_file_id(self, name):
        clean_name = os.path.basename(name)
        
        escaped_name = clean_name.replace('\\', '\\\\').replace('"', '\\"')
        
        query = f'name="{escaped_name}" and trashed=false'
        if self.folder_id:
            query += f" and '{self.folder_id}' in parents"

        response = self.service.files().list(
            q=query, spaces="drive", fields="files(id, name)", pageSize=1
        ).execute()
        files = response.get("files", [])
        return files[0]["id"] if files else None


    def _save(self, name, content):
        file_metadata = {'name': os.path.basename(name)}
        if self.folder_id:
            file_metadata['parents'] = [self.folder_id]

        media = MediaIoBaseUpload(content, mimetype=self._get_mimetype(name), resumable=True)

        created_file = self.service.files().create(
            body=file_metadata,
            media_body=media,
            fields='id'
        ).execute()

        # Make file public (optional)
        if getattr(settings, 'GOOGLE_DRIVE_PUBLIC_UPLOADS', True):
            self.service.permissions().create(
                fileId=created_file['id'],
                body={'type': 'anyone', 'role': 'reader'},
                fields='id'
            ).execute()

        return name

    def exists(self, name):
        return self._get_file_id(name) is not None

    def delete(self, name):
        file_id = self._get_file_id(name)
        if file_id:
            self.service.files().delete(fileId=file_id).execute()

    def url(self, name):
        file_id = self._get_file_id(name)
        if not file_id:
            return None
        return f"https://drive.google.com/uc?id={file_id}&export=download"

    def size(self, name):
        file_id = self._get_file_id(name)
        if not file_id:
            return 0
        metadata = self.service.files().get(fileId=file_id, fields='size').execute()
        return int(metadata.get('size', 0))

    def open(self, name, mode='rb'):
        file_id = self._get_file_id(name)
        if not file_id:
            raise FileNotFoundError(f"No file named '{name}' in Google Drive.")

        request = self.service.files().get_media(fileId=file_id)
        fh = io.BytesIO()
        downloader = MediaIoBaseDownload(fh, request)
        done = False
        while not done:
            _, done = downloader.next_chunk()
        fh.seek(0)
        return fh
