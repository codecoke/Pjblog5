﻿<%if ( data.pages.arrays.length > 1 ){%>
<div class="page">
<%
		data.pages.arrays.forEach(function( o ){
			if ( data.pages.value.index === o ){
%>
		<b><%=o%></b>
<%		
			}else{
%>
		<a href="<%=iPress.setURL.apply(iPress, data.contains.page(o))%>"><%=o%></a>
<%			
			}
		});
%>
</div>
<%};%>