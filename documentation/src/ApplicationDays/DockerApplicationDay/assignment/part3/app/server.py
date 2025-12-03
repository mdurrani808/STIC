from http.server import HTTPServer, BaseHTTPRequestHandler
import json

class SimpleHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/':
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            response = {
                "message": "Simple Python HTTP Server",
                "status": "running"
            }
            self.wfile.write(json.dumps(response).encode())
        else:
            self.send_response(404)
            self.end_headers()

    def log_message(self, format, *args):
        print(f"[{self.address_string()}] {format % args}")

def run_server(port=8080):
    server_address = ('', port)
    httpd = HTTPServer(server_address, SimpleHandler)
    print(f"Server running on port {port}...")
    httpd.serve_forever()

if __name__ == '__main__':
    run_server()
