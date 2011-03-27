<%@ include file="/WEB-INF/template/include.jsp"%>

<%@ include file="/WEB-INF/template/header.jsp"%>

<link rel="stylesheet" href="<openmrs:contextPath/>/moduleResources/messaging/css/inbox.css" type="text/css"/>
<table id="index">
	<tr>
	<td id="link-cell">
		<div id="link-panel">
			<a id="inbox-link" class="panel-link" href="<openmrs:contextPath/>/module/messaging/inbox.form">OMail Inbox</a>
			<a id="compose-message-link" class="panel-link" href="<openmrs:contextPath/>/module/messaging/compose_message.form">Compose Message</a>
			<a id="sent-messages-link" class="panel-link" href="<openmrs:contextPath/>/module/messaging/sent_messages.form">Sent Messages</a>
			<a id="settings-link" class="panel-link" href="<openmrs:contextPath/>/module/messaging/settings.form">Settings</a>
		</div>
	</td>
	<td id="inbox">
		<div id="search-bar-container">
			<input id="inbox-search" type="text"/>
		</div><br/>
		<div id="message-table-container">
			<div id="loading-container">
				<div id="inner-loading-container">
					<span id="loading-text">Loading...</span>
					<img src="resources/images/ajax-loading-bar.gif"/>
				</div>
			</div>
			<table id="messages-table" class="message-table">
				<thead>
					<tr>
						<th>From</th>
						<th>Message</th>
						<th>Date</th>
					</tr>
				</thead>
				<tbody id="messages-table-body">
					<tr class="message-row" id="pattern" style="display:none;">
						<td class="message-row-from" id="message-from"></td>
						<td class="message-row-subject" id="message-subj"></td>
						<td class="message-row-date" id="message-date"></td>
					</tr>			
				</tbody>
			</table>
			<div id="paging-controls-container">
				<span id="paging-controls">
					<span id="paging-info">1 to 15 of 234</span>
					<a href="" id="1">&lt;&lt;</a>
					<a href="" id="1">&lt;</a>
					<span id="current-page">1</span>
					<a href="" id="1">&gt;</a>
					<a href="" id="1">&gt;&gt;</a>
				</span>
			</div>
		</div>
		<div id="message-panel">
		<div id="message-info-panel" class="boxHeader">
			<table id="message-header-table">
				<tr><td class="header-label">From: </td><td class="header-info" id="header-from"></td></tr>
				<tr><td class="header-label">Subject: </td><td class="header-info" id="header-subject"></td></tr>
				<tr><td class="header-label">Date: </td><td class="header-info" id="header-date"></td></tr>
				<tr><td class="header-label">To: </td><td class="header-info" id="header-to"></td></tr>
			</table>
			<div id="reply-buttons">
				<button id="reply-button" type="button">Reply</button>
				<button id="reply-all-button" type="button">Reply All</button>
			</div>
			<div style="clear:both;"></div>
		</div>
		<div id="message-text-panel">
		</div>
		</div>
	</td>
	</tr>
</table>

<%@ include file="/WEB-INF/template/footer.jsp" %>

<script src="<openmrs:contextPath/>/moduleResources/messaging/jquery/jquery-1.4.4.min.js"></script>
<script src="<openmrs:contextPath/>/moduleResources/messaging/jquery/jquery.watermark.min.js"></script>
<openmrs:htmlInclude file="/dwr/engine.js"/>
<openmrs:htmlInclude file="/dwr/util.js"/>
<script src="<openmrs:contextPath/>/dwr/interface/DWRModuleMessageService.js"></script>

<script type="text/javascript">	
	window.onload = init;
	
	var messageCache = { };
	var messageTableVisible =true;
	var pageNum=0;
	var pageSize=10;
	
	function init() {
		$("#inbox-search").watermark("search mail");
		$("#messages-table-body tr").live("click",rowClicked);
		fillMessageTable();
	}
	
	function rowClicked(event){
		var id = event.srcElement.id.substring(12);
		var message = messageCache[id];
		document.getElementById("message-panel").style.display="";
		document.getElementById("header-from").innerHTML = message.sender;
		document.getElementById("header-subject").innerHTML = message.subject;
		document.getElementById("header-date").innerHTML = message.date;
		document.getElementById("header-to").innerHTML = message.recipients;
		document.getElementById("message-text-panel").innerHTML = message.content;
		$("#messages-table-body").children().removeClass("highlight-row");
		$("#pattern"+id).addClass("highlight-row");	
		$("#reply-buttons").css("visibility","visible");
		$(".header-label").css("visibility","visible");
	}
	
	function fillMessageTable(){
		toggleMessageLoading();
		DWRModuleMessageService.getMessagesForAuthenticatedUserWithPageSize(pageNum,pageSize,true,function(messages){
			dwr.util.removeAllRows("messages-table-body", { filter:function(tr) {return (tr.id != "pattern");}});
			var message, id;
			// iterate through the messages, cloning the pattern row
			// and placing each message values into that row
			for (var i = 0; i < messages.length; i++) {
				message = messages[i];
			    id = message.id;
			    dwr.util.cloneNode("pattern", { idSuffix:id });
			    dwr.util.setValue("message-from" + id, message.sender);
			    dwr.util.setValue("message-subj" + id, message.subject);
			    dwr.util.setValue("message-date" + id, message.time+ " " + message.date);
			    document.getElementById("pattern" + id).style.display = "table-row";
			    messageCache[id] = message;
			}
			toggleMessageLoading();
		});
	}
	
	function messageClicked(event){}
	
	function replyClicked(event){}
	
	function replyAllClicked(event){}

	function toggleMessageLoading(){
		if(messageTableVisible){
			document.getElementById("messages-table").style.display="none";
			document.getElementById("paging-controls-container").style.display="none";
			document.getElementById("loading-container").style.display="";
			messageTableVisible=false;
		}else{
			document.getElementById("messages-table").style.display="";
			document.getElementById("paging-controls-container").style.display="";
			document.getElementById("loading-container").style.display="none";
			messageTableVisible=true;
		}
	}
</script>