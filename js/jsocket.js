/*
 * Jsocket - Socket on Javascript
 * Author: Masahiro Chiba <nihen@megabbs.com>
 * Depends:
 *  - jQuery: http://jquery.com/
 *  - jQuery TOOLS - Flashembed: http://flowplayer.org/tools/flashembed.html
 * SYNOPSIS:
 *  JSocket.init('/static/JSocket.swf', function () {
 *     socket = new JSocket({
 *         connectHandler: connectHandler,
 *         dataHandler:    dataHandler,
 *         closeHandler:   closeHandler,
 *         errorHandler:   errorHandler
 *     });
 *     socket.connect(location.hostname, location.port || 80);
 *  });
 *  function connectHandler() {
 *      socket.write("GET / HTTP/1.0\x0D\x0A\x0D\x0A");
 *      socket.flush();
 *  }
 *  function dataHandler(data) {
 *      alert(data);
 *      socket.close();
 *  }
 *  function closeHandler() {
 *      alert('lost connection')
 *  }
 *  function errorHandler(errorstr) {
 *      alert(errorstr);
 *  }
 *  
 * */
function JSocket() {
    this.initialize.apply(this, arguments);
}
JSocket.VERSION = '0.01';
JSocket.init = function(src, swfloadedcb) {
    JSocket.flashapi = $('<div></div>').appendTo('body').flashembed({
        id: 'socketswf',
        name: 'socketswf',
        src: src.concat('?'.concat(JSocket.VERSION)),
        allowfullscreen: false,
        width: '1px',
        height: '1px',
        wmode: 'transparent',
        bgcolor: '#ffffff',
        allowScriptAccess: 'always'
    }).getApi();
    JSocket.swfloadedcb = swfloadedcb;
};
JSocket.swfloaded = function() {
    if ( JSocket.swfloadedcb ) {
        JSocket.swfloadedcb();
    }
};
JSocket.handlers = new Array();
JSocket.handler = function(socid, handlename) {
    if ( JSocket.handlers[socid][handlename] ) {
        if ( arguments.length == 3 ) {
            JSocket.handlers[socid][handlename](arguments[2]);
        }
        else {
            JSocket.handlers[socid][handlename]();
        }
    }
};
JSocket.prototype = {
    initialize: function(handlers) {
        this.socid    = JSocket.flashapi.newsocket();
        JSocket.handlers[this.socid] = handlers;
    },
    connect: function(host, port) {
        JSocket.flashapi.connect(this.socid, host, port);
    },
    write: function(data) {
       JSocket.flashapi.write(this.socid, data);
    },
    close: function() {
        JSocket.flashapi.close(this.socid);
    },
    flush: function() {
        JSocket.flashapi.flush(this.socid);
    }
};
