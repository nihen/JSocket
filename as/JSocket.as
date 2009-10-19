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

        public function newsocket(handlers:Object):int {
            var soc:Socket = new Socket();

            soc.addEventListener(Event.CONNECT,                     function (e:Event):void { connectHandler(e, soc, handlers.connectHandler) });
            soc.addEventListener(ProgressEvent.SOCKET_DATA,         function (e:Event):void { dataHandler(e, soc, handlers.dataHandler) } );
            soc.addEventListener(Event.CLOSE,                       function (e:Event):void { closeHandler(e, soc, handlers.closeHandler); } );
            soc.addEventListener(IOErrorEvent.IO_ERROR,             function (e:Event):void { errorHandler(e, soc, handlers.errorHandler); } );
            soc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function (e:Event):void { errorHandler(e, soc, handlers.errorHandler); } );

            sockets.push(soc);
            return sockets.length - 1;
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

        private function connectHandler(event:Event, soc:Socket, handler:String):void {
            if ( handler ) {
                ExternalInterface.call(handler);
            }
        }
        private function closeHandler(event:Event, soc:Socket, handler:String):void {
            if ( handler ) {
                ExternalInterface.call(handler);
            }
        }

        private function dataHandler(event:Event, soc:Socket, handler:String):void {
            var buffer:String = soc.readUTFBytes(soc.bytesAvailable);
            if ( handler ) {
                ExternalInterface.call(handler, buffer);
            }
        }

        private function errorHandler(event:Event, soc:Socket, handler:String):void {
            if ( handler ) {
                ExternalInterface.call(handler, event.toString());
            }
        }

    }
}
