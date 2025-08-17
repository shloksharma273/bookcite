# import http.client

# conn = http.client.HTTPSConnection("chatgpt-42.p.rapidapi.com")

# payload = '{"messages":[{"role":"user","content":"hi"}],"web_access":false}'

# headers = {
#     'x-rapidapi-key': "f9a37c9e88msh2cf6f14cb2628e8p1b4644jsn1481e0db4996",
#     'x-rapidapi-host': "chatgpt-42.p.rapidapi.com",
#     'Content-Type': "application/json"
# }

# conn.request("POST", "/gpt4o", payload, headers)

# res = conn.getresponse()
# data = res.read()

# print(data.decode("utf-8"))