package {
    import flash.display.Sprite;
    import flash.events.*;
    import flash.net.Socket;
    import flash.system.Security;

    import flash.external.*;

    public class JSocket extends Sprite
    {
        private var sockets:Array = new Array();
        private var handlers:Object;

        public function JSocket():void {
            if (stage) init();
            else addEventListener(Event.ADDED_TO_STAGE, init);
        }
        
        private function init(e:Event = null):void {
            removeEventListener(Event.ADDED_TO_STAGE, init);

            ExternalInterface.addCallback('newsocket', newsocket);
            ExternalInterface.addCallback('connect', connect);
            ExternalInterface.addCallback('write', write);
            ExternalInterface.addCallback('flush', flush);
            ExternalInterface.addCallback('close', close);

            ExternalInterface.call('JSocket.swfloaded');
        }

        public function newsocket():int {
            var soc:Socket = new Socket();

            sockets.push(soc);
            var socid:int = sockets.length - 1;

            soc.addEventListener(Event.CONNECT,                     function (e:Event):void { connectHandler(e, socid) });
            soc.addEventListener(ProgressEvent.SOCKET_DATA,         function (e:Event):void { dataHandler(e, socid) } );
            soc.addEventListener(Event.CLOSE,                       function (e:Event):void { closeHandler(e, socid); } );
            soc.addEventListener(IOErrorEvent.IO_ERROR,             function (e:Event):void { errorHandler(e, socid); } );
            soc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function (e:Event):void { errorHandler(e, socid); } );

            return socid;
        }

        public function connect(socid:int, host:String, port:int):void {
            sockets[socid].connect(host, port);
        }
        public function write(socid:int, data:String):void {
            sockets[socid].writeUTFBytes(data);
        }
        public function flush(socid:int):void {
            sockets[socid].flush();
        }
        public function close(socid:int):void {
            sockets[socid].close();
        }

        private function connectHandler(event:Event, socid:int):void {
            ExternalInterface.call('JSocket.handler', socid, 'connectHandler');
        }
        private function closeHandler(event:Event, socid:int):void {
            ExternalInterface.call('JSocket.handler', socid, 'closeHandler');
        }

        private function dataHandler(event:Event, socid:int):void {
            var soc:Socket = sockets[socid];
            var buffer:String = soc.readUTFBytes(soc.bytesAvailable);
            ExternalInterface.call('JSocket.handler', socid, 'dataHandler', buffer);
        }

        private function errorHandler(event:Event, socid:int):void {
            ExternalInterface.call('JSocket.handler', socid, 'errorHandler', event.toString());
        }
    }
}
