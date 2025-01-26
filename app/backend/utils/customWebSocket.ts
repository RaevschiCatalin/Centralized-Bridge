import WebSocket from 'ws';

class CustomWebSocket extends WebSocket {
  dispatchEvent(event: Event): boolean {

    return true;
  }
}

export default CustomWebSocket;