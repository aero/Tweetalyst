$(function() {
    // creating our buttons
    $(".options").find("a").button();
    $("#submit").button();

    // search bar effects
    var searchDefault = "Search Tweetylicious...";
    $("#search").val(searchDefault);
    $("#search").focus( function() {
        if($(this).val() == searchDefault) $(this).val("");
    });
    $("#search").blur(function(){
        if($(this).val() == "") $(this).val(searchDefault);
    });

    // showing how many characters are left
    $("#charsleft").text("140 characters left");
    $("#message").keyup(function() {
       var left = 140 - $("#message").val().length;
       if (left < 0 ) {
         $("#charsleft").removeClass("orange").addClass("red");
         $("#submit").button("option", "disabled", true);
       } else {
         $("#submit").button("option", "disabled", false);
         if (left < 40) {
           $("#charsleft").removeClass("red").addClass("orange");
         } else {
           $("#charsleft").removeClass("red").removeClass("orange");
         }
       }
       $("#charsleft").text( left + ' characters left' );
    });

    // highlighting selection
    $("#content ul.messages li").hover(
        function() { $(this).animate( {backgroundColor:'#ded'}, 400 ); },
        function() { $(this).animate( {backgroundColor:'#efe'}, 400 ); }
    );

    /* if user has javascript enabled, we turn
       'delete post' and 'tell the world' buttons into Ajax
       (well, actually Ajaj, since we use JSON ;) */
    function send_to_trash(event) {
        event.preventDefault();
        var item = this;
        var href = $(item).attr("href");
        $.getJSON(href, function(json) {
          if (json.answer) {
            $(item).parent("li").hide("explode", {}, 1000);
          }
        });
    }
    $("a.ui-icon").click(send_to_trash);

    $("#submit").click(function(event) {
        event.preventDefault();
        var href = $("#post").attr("action");
        $.post(href, $("#post").serialize(), function(data) {
            $("#message").text("");
            $("#content ul").prepend('<li style="display:none" class="ui-corner-all"><a href="/' + data.username + '/post/' + data.id + '/delete" class="ui-icon ui-icon-trash" title="delete this post"></a><a class="who" href="/' + data.username + '"><img src="http://www.gravatar.com/avatar/' + data.gravatar + '?s=60.jpg" />' + data.username + '</a><span class="what">' + data.content + '</span><span class="when">' + data.date + '</span></li>');
            $("#content li:first").show("drop", {}, 1000);
            $("#content li:first").find("a.ui-icon").click(send_to_trash);
        }, "json");
    });

    // formatting our content
    $(".what").each(function() {
        var message = $(this).html()
                  .replace(/@(\w+)/g, "@<a href=\"/$1\">$1</a>")
                  .replace(/#(\w+)/g, "<a href=\"/search?query=%23$1\">#$1</a>");
        $(this).html(message);
    });
});

