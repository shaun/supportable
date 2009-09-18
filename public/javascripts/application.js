var SupportableChat = {
	start: function(url_name,drop_name,chat_password,for_employees) {
		SupportableChat.url_name = url_name;
		
		DropioStreamer.observe(DropioStreamer.JOINED_CHAT, SupportableChat.iJoined.bind(SupportableChat));
		DropioStreamer.observe(DropioStreamer.LEFT_CHAT, SupportableChat.iLeft.bind(SupportableChat));
	    DropioStreamer.observe(DropioStreamer.STREAM_DISCONNECTED, SupportableChat.iLeft.bind(SupportableChat));
		DropioStreamer.observe(DropioStreamer.USER_JOINED, SupportableChat.employeeJoined.bind(SupportableChat));
		DropioStreamer.observe(DropioStreamer.USER_LEFT, SupportableChat.employeeLeft.bind(SupportableChat));
		DropioStreamer.observe(DropioStreamer.RECEIVED_MESSAGE, SupportableChat.receivedMessage.bind(SupportableChat));
		
		// start the stream
		DropioStreamer.start(drop_name,chat_password);
		
		if( for_employees )
			setTimeout(function() { SupportableChat.pollCounts() }, 5000);
	},
	
	iJoined: function(data) {
		SupportableChat.my_nickname = data.nickname;
		SupportableChat.displayNick(data.nickname);
	},
	
	iLeft: function(data) {
		console.info(" I LEFT");
		
	},
	
	employeeJoined: function(data) {
		if( data.nickname != SupportableChat.my_nickname)
			SupportableChat.displayNick(data.nickname);
	},
	
	employeeLeft: function(data) {
		$(data.nickname).remove();
	},
	
	receivedMessage: function(data) {
		if( data.nickname != SupportableChat.my_nickname )
			SupportableChat.displayMessage(data.nickname,data.message);
	},
	
	pollCounts: function() {
		new Ajax.Request("/" + SupportableChat.url_name + "/counts", {
			method: "post",
			parameters: {},
			onComplete: function(transport) {
				var json = transport.responseJSON;
				if( json ) {
					$("self_help_count").update(json["self_help"])
					$("need_help_count").update(json["need_help"])
					$("help_arrived_count").update(json["help_arrived"])
					$("problem_solved_count").update(json["problem_solved"])	
				}
				setTimeout(function() { SupportableChat.pollCounts() }, 5000);
			}
		})
	},
	
	sendMessage: function() {
		var str = $("message").value
		DropioStreamer.sendMessage(str);
		$("message").value = ""
		SupportableChat.displayMessage(SupportableChat.my_nickname,str)
	},
	
	displayMessage: function(nick,str) {
		$("chatWindow").insert({bottom:"<div>" + nick + ": " + str + "</div>"});	
	},
	
	displayNick: function(nick) {
		$("nickList").insert("<div id='" + nick + "'>" + nick + "</div>");	
	}
}

var Customer = {
	init_support: function(url_name) {
		Customer.url_name = url_name; 
		new Ajax.Request("/" + url_name + "/init_support", {
			method: "post",
			parameters: {},
			onComplete: function(transport) {
				var json = transport.responseJSON;
				if( json && json.success ) {
					top.location = "/" + Customer.url_name + "/support"
				}
				else {
					alert("Sorry, something went wrong while starting your Customer Support session. Please refresh this page and try again.")
				}
			}
		})
	}
}