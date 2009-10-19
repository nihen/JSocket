/*
 * Jsocket
 * Author: Masahiro Chiba <nihen@megabbs.com>
 * Depends:
 *  - jQuery: http://jquery.com/
 *  - jQuery TOOLS - Flashembed: http://flowplayer.org/tools/flashembed.html
 * */
function JSocket() {
    this.initialize.apply(this, arguments);
}
JSocket.init = function(src, swfloadedcb) {
    JSocket.flashapi = $('<div></div>').appendTo('body').flashembed({
        id: 'socketswf',
        name: 'socketswf',
        src: src,
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
JSocket.prototype = {
    initialize: function(handlers) {
        this.handlers = handlers;
        this.socid    = JSocket.flashapi.newsocket(handlers);
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
