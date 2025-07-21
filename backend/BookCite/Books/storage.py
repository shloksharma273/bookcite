# from django.core.files.storage import Storage
# from django.conf import settings
# from django.core.exceptions import ImproperlyConfigured
# import os
# import io
# import pickle
# # Google API client libraries
# from google.auth.transport.requests import Request
# from google.oauth2.credentials import Credentials
# from google_auth_oauthlib.flow import InstalledAppFlow
# from googleapiclient.discovery import build
# # CORRECTED: Added MediaIoBaseUpload to imports
# from googleapiclient.http import MediaIoBaseDownload, MediaIoBaseUpload
# from googleapiclient.errors import HttpError

# class GoogleDriveStorage(Storage):
#     """
#     Custom Django Storage backend for Google Drive.
#     This implementation uses the Google Drive API to store and retrieve files.
#     Authentication is handled via OAuth 2.0 (user consent flow for local development).
#     """

#     # If modifying these scopes, delete the file token.json.
#     SCOPES = ['https://www.googleapis.com/auth/drive.file'] # Allows access to files created by the app

#     def __init__(self, credentials_file=None, token_file=None, root_folder_id=None):
#         self.credentials_file = credentials_file or getattr(settings, 'GOOGLE_DRIVE_CREDENTIALS_FILE', None)
#         self.token_file = token_file or getattr(settings, 'GOOGLE_DRIVE_TOKEN_FILE', None)
#         self.root_folder_id = root_folder_id or getattr(settings, 'GOOGLE_DRIVE_ROOT_FOLDER_ID', None)

#         if not self.credentials_file:
#             raise ImproperlyConfigured("GOOGLE_DRIVE_CREDENTIALS_FILE not set in settings.")

#         self._service = None # Will be initialized on first access

#     @property
#     def service(self):
#         """Initializes and returns the Google Drive API service."""
#         if self._service is None:
#             creds = None
#             # The file token.json stores the user's access and refresh tokens, and is
#             # created automatically when the authorization flow completes for the first
#             # time.
#             if os.path.exists(self.token_file):
#                 creds = Credentials.from_authorized_user_file(self.token_file, self.SCOPES)
#             # If there are no (valid) credentials available, let the user log in.
#             if not creds or not creds.valid:
#                 if creds and creds.expired and creds.refresh_token:
#                     creds.refresh(Request())
#                 else:
#                     # This flow will open a browser for user authentication on first run
#                     # For web applications, you'd use InstalledAppFlow.from_client_secrets_file
#                     # with a redirect URI. For local dev, desktop app flow is simpler.
#                     flow = InstalledAppFlow.from_client_secrets_file(
#                         self.credentials_file, self.SCOPES)
#                     creds = flow.run_local_server(port=0)
#                 # Save the credentials for the next run
#                 with open(self.token_file, 'wb') as token:
#                     pickle.dump(creds, token)

#             self._service = build('drive', 'v3', credentials=creds)
#         return self._service

#     def _save(self, name, content):
#         """
#         Saves a file to Google Drive.
#         `name` is the full path including filename (e.g., 'book_pdf/my_book.pdf').
#         `content` is a Django File object.
#         """
#         # Ensure the content is reset to the beginning if it's already been read
#         if hasattr(content, 'seek') and content.seekable():
#             content.seek(0)

#         # Determine the MIME type based on the file extension
#         mime_type = 'application/octet-stream' # Default
#         if name.endswith('.pdf'):
#             mime_type = 'application/pdf'
#         elif name.endswith(('.jpg', '.jpeg')):
#             mime_type = 'image/jpeg'
#         elif name.endswith('.png'):
#             mime_type = 'image/png'
#         # Add more MIME types as needed

#         file_metadata = {'name': os.path.basename(name)}
#         if self.root_folder_id:
#             file_metadata['parents'] = [self.root_folder_id]

#         # CORRECTED: Use MediaIoBaseUpload with content.file for file-like objects
#         media_body = MediaIoBaseUpload(content.file,
#                                      mimetype=mime_type,
#                                      resumable=True)

#         try:
#             # Check if a file with the same name already exists in the target folder
#             # This is a basic check; for robust handling, you might want to version files
#             # or use unique names.
#             query = f"name = '{os.path.basename(name)}' and trashed = false"
#             if self.root_folder_id:
#                 query += f" and '{self.root_folder_id}' in parents"
            
#             response = self.service.files().list(
#                 q=query,
#                 spaces='drive',
#                 fields='files(id, name)').execute()
            
#             existing_files = response.get('files', [])

#             if existing_files:
#                 # If file exists, update it
#                 file_id = existing_files[0]['id']
#                 updated_file = self.service.files().update(
#                     fileId=file_id,
#                     media_body=media_body,
#                     fields='id, webViewLink, webContentLink').execute()
#                 print(f"DEBUG: Updated existing file in Google Drive: {updated_file.get('id')}")
#             else:
#                 # If file does not exist, create new
#                 created_file = self.service.files().create(
#                     body=file_metadata,
#                     media_body=media_body,
#                     fields='id, webViewLink, webContentLink').execute()
#                 print(f"DEBUG: Created new file in Google Drive: {created_file.get('id')}")
#                 # Make the file publicly accessible for viewing/downloading (optional, but needed for direct links)
#                 # This step is often required for direct public access.
#                 # Be careful with sensitive files.
#                 self.service.permissions().create(
#                     fileId=created_file.get('id'),
#                     body={'type': 'anyone', 'role': 'reader'},
#                     fields='id'
#                 ).execute()
#                 updated_file = created_file # Use the created file's info

#             # Return the file ID as the 'name' Django expects to store
#             # This ID is what Django's FileField will store in the database.
#             return updated_file.get('id') # Store the Google Drive File ID

#         except HttpError as error:
#             print(f'An error occurred: {error}')
#             raise

#     def _open(self, name, mode='rb'):
#         """
#         Opens a file from Google Drive.
#         `name` here is the Google Drive File ID stored in the database.
#         """
#         if mode != 'rb':
#             raise NotImplementedError("GoogleDriveStorage only supports reading in binary mode ('rb').")

#         try:
#             file_id = name # 'name' is the Google Drive File ID
#             # Download the file content
#             request = self.service.files().get_media(fileId=file_id)
#             file_content = io.BytesIO()
#             downloader = MediaIoBaseDownload(file_content, request)
#             done = False
#             while done is False:
#                 status, done = downloader.next_chunk()
#                 # print(f"Download {int(status.progress() * 100)}%.")
#             file_content.seek(0) # Reset buffer to the beginning
#             return file_content # Return a file-like object
#         except HttpError as error:
#             print(f'An error occurred during _open: {error}')
#             raise FileNotFoundError(f"File with ID {name} not found or accessible on Google Drive.")

#     def delete(self, name):
#         """Deletes a file from Google Drive."""
#         try:
#             # 'name' is the Google Drive File ID
#             self.service.files().delete(fileId=name).execute()
#             print(f"DEBUG: Deleted file with ID {name} from Google Drive.")
#         except HttpError as error:
#             print(f'An error occurred during delete: {error}')
#             # Don't raise an error if file not found, just log it.
#             if error.resp.status == 404:
#                 print(f"DEBUG: File with ID {name} not found when trying to delete.")
#             else:
#                 raise

#     def exists(self, name):
#         """Checks if a file exists on Google Drive."""
#         try:
#             # 'name' is the Google Drive File ID
#             self.service.files().get(fileId=name, fields='id').execute()
#             return True
#         except HttpError as error:
#             if error.resp.status == 404:
#                 return False
#             print(f'An error occurred during exists: {error}')
#             raise

#     def url(self, name):
#         """
#         Returns the public web view link for the file.
#         `name` is the Google Drive File ID.
#         """
#         try:
#             file_id = name
#             file_metadata = self.service.files().get(
#                 fileId=file_id, fields='webViewLink').execute()
#             return file_metadata.get('webViewLink')
#         except HttpError as error:
#             print(f'An error occurred during url generation: {error}')
#             return None

#     # Required for Django's Storage API, but not directly used by Google Drive
#     def _save_path(self, name):
#         return name

#     def get_available_name(self, name, max_length=None):
#         """
#         Returns a filename that is available. Google Drive handles duplicates by creating new files
#         or updating existing ones based on the logic in _save.
#         For simplicity, we'll just return the proposed name.
#         """
#         return name


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
from google.oauth2.credentials import Credentials


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
        query = f"name='{name}' and trashed=false"
        if self.folder_id:
            query += f" and '{self.folder_id}' in parents"

        results = self.service.files().list(
            q=query,
            spaces='drive',
            fields="files(id, name)",
        ).execute()

        files = results.get('files', [])
        return files[0]['id'] if files else None

    def _save(self, name, content):
        file_metadata = {'name': name}
        if self.folder_id:
            file_metadata['parents'] = [self.folder_id]

        media = MediaIoBaseUpload(content, mimetype=self._get_mimetype(name), resumable=True)

        created_file = self.service.files().create(
            body=file_metadata,
            media_body=media,
            fields='id, webViewLink'
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
