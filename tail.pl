#!/usr/bin/perl

use CGI qw(:standard);
use File::Tail;

$| = 1; #set auto flush on

$q = new CGI;
print header();

print <<'WEBPAGE';
<html>
<head>
<title>Syncapse Log Viewer</title>
</head>
<body style="font-family:arial;font-size:12px;padding-bottom:30px;" data-scroll='{"x":"0", "y":"0"}'>
    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"> </script>
    <script src="//fgnass.github.io/spin.js/spin.min.js"> </script>
    <script type="text/javascript">
    var timer = null;
  function startscroll ()
  { console.log("Starting");
   timer =  window.setInterval(function()
    {
        window.scrollTo(0, document.body.scrollHeight);
    },50);
  }
  function stopscroll () {
        console.log("Stopping");
        clearInterval(timer);
        timer = null;
   }
   window.onscroll = function() {
        var scrollData = $('body').data('scroll');
        var action = null;
        
        if(scrollData.y > $(this).scrollTop()){
              console.log("up");
              action = "up";
        }else if(scrollData.y != $(this).scrollTop()){
              console.log("down");
              action = "down";
        }
        
        
        scrollData.y = $(this).scrollTop();
        $('body').data('scroll', scrollData);

        if (atthebottom() && timer == null && action == "down" ) {
                startscroll();
        }
        if (timer != null && action == "up" ) {
                stopscroll();
        }
    };


function atthebottom() {
    var myWidth = 0,
        myHeight = 0;
    if (typeof(window.innerWidth) == 'number') {
        //Non-IE
        myWidth = window.innerWidth;
        myHeight = window.innerHeight;
    } else if (document.documentElement && (document.documentElement.clientWidth || document.documentElement.clientHeight)) {
        //IE 6+ in 'standards compliant mode'
        myWidth = document.documentElement.clientWidth;
        myHeight = document.documentElement.clientHeight;
    } else if (document.body && (document.body.clientWidth || document.body.clientHeight)) {
        //IE 4 compatible
        myWidth = document.body.clientWidth;
        myHeight = document.body.clientHeight;
    }
    var scrolledtonum = window.pageYOffset + myHeight + 2;
    var heightofbody = document.body.offsetHeight;
    return scrolledtonum >= heightofbody ;
}


    startscroll();
    document.getElementsByTagName("body")[0].addEventListener("click", stopscroll);

var opts = {
  lines: 13, // The number of lines to draw
  length: 6, // The length of each line
  width: 2, // The line thickness
  radius: 8, // The radius of the inner circle
  corners: 1, // Corner roundness (0..1)
  rotate: 0, // The rotation offset
  color: '#000', // #rgb or #rrggbb
  speed: 1, // Rounds per second
  trail: 60, // Afterglow percentage
  shadow: false, // Whether to render a shadow
  hwaccel: false, // Whether to use hardware acceleration
  className: 'spinner', // The CSS class to assign to the spinner
  zIndex: 2e9, // The z-index (defaults to 2000000000)
  //top: 'auto', // Top position relative to parent in px
  left: '0' // Left position relative to parent in px
};
    var target = document.getElementsByTagName('body')[0];
    var spinner = new Spinner(opts).spin(target);
    </script>
WEBPAGE

$file_name = $q->param('file');
$tail_file=File::Tail->new(name=>$file_name,
                            maxinterval=>30,
                            adjustafter=>5,
                            maxbuf=>16384,
                            tail=>100);

while (defined($readline=$tail_file->read))
{
    print $readline."<br>";
    print "<script>\$('.spinner').css('top', document.body.offsetHeight - 10)</script>";
}
print "</body>";
print "</html>";

