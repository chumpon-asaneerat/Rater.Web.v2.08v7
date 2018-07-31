;(function () {
    function unifyHeights() {
        var $win = $(window);
        console.log($win);
        var winH = Math.floor($win.innerHeight());
        console.log('window height:', winH);

        var $container = $('.area');

        var $header = $('.header');
        var headerH = Math.ceil($header.outerHeight(true));
        console.log('header height:', headerH);

        var $main = $('.main');
        var mainH = Math.ceil($main.outerHeight(true));
        var mainMH = mainH - Math.ceil($main.height());
        console.log('main height:', mainH);
        console.log('main margin height:', mainMH);

        var $sidebar = $('.sidebar');
        var sidebarH = Math.ceil($sidebar.outerHeight(true));
        var sidebarMH = sidebarH - Math.ceil($sidebar.height());
        console.log('sidebar height:', sidebarH);
        console.log('sidebar margin height:', sidebarMH);

        $('.main, .sidebar').outerHeight(winH - headerH - 1);
        
        /*
        var siblings = $container.siblings();
        var iCnt = siblings.length;
        var siblingsHeight = 0;
        for (var i = 0; i < iCnt; ++i) {
            var $slibing = $(siblings[i]);
            //console.log($slibing, $slibing.outerHeight());
            if ($slibing)
                siblingsHeight += $slibing.height();
        }
        var maxHeight = $win.height() - siblingsHeight;
        */
        //$container.css('height', maxHeight);
        /*
        $container.children('.main, .sidebar').each(function () {
            console.log(this);
            var height = $(this).outerHeight();
            maxHeight = Math.max(height, maxHeight);
        });
        console.log(maxHeight);
        */
        //$('.main, .sidebar').css('height', maxHeight);
        //$('.main, .sidebar').height(maxHeight);

        //console.log($('.main').height());
        //console.log($('.sidebar').height());
    }

    $(window).on('resize', function() {
        unifyHeights();
    });

    unifyHeights();
})();
