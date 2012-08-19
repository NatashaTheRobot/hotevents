$(function(){

  var $container = $('#eventcontainer');

  $container.imagesLoaded(function(){
      $container.masonry({
         itemSelector: '.eventbox',
       });
     });

  $container.masonry({
       itemSelector : '.eventbox',
       isAnimated: true
			 columnWidth: function( containerWidth ) {
		    return containerWidth / 4;
		  }
   });

  $container.infinitescroll(
    {
      navSelector  : '#page-nav',    // selector for the paged navigation
      nextSelector : '#page-nav a',  // selector for the NEXT link (to page 2)
      itemSelector : '.eventbox',     // selector for all items you'll retrieve
      animate      : true,
      debug        : true,
      loadingText  : "loading..."
    },

    function( newElements ) {
      var $newElems = $( newElements ).css({ opacity: 0 });
      $newElems.animate({ opacity: 1 });
      $container.masonry( 'appended', $newElems, true );
    }
  );



});
