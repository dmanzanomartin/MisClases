import secrets
import asyncio
import json
from py import process
import websockets

clients={}

server_url = "localhost"

async def broadcast_msg(msg):
    for c in clients:
        await clients[c].send(msg)

async def process(msg):
    data = json.loads(msg)
    username = data["username"]
    client = data["client"]
    text = data["text"]
    print(client)
    print(clients)
    print()
    if(client not in clients):
        await clients[username].send("Error, el cliente no está registrado")
        print("Error, el cliente no está registrado")
        return
    await clients[client].send(text)

async def handler(ws):
    data = await ws.recv()
    data = json.loads(data)
    username=data["username"]
    if(username not in clients):
        print(f"Usuario {username} registrado")
        clients[username]=ws
    await broadcast_msg(json.dumps(list(clients.keys())))
    while True:
        try:
            msg = await ws.recv()
        except websockets.ConnectionClosedOK:
            clients.pop(username)
            print(f"El cliente {username} ha salido de la sesión")
            break
        await process(msg)
    
    

async def main():
    print("Starting")
    async with websockets.serve(handler, server_url, 8001):
        await asyncio.Future()  # run forever

if __name__ == "__main__":
    asyncio.run(main())