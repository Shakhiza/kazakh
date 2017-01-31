<%@page import="java.util.Collections"%>
<%@page import="java.util.Random"%>
<%@page import="main.Word"%>
<%@include file="mysql.jsp" %>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script type="text/javascript" src="http://code.jquery.com/jquery-1.10.1.min.js"></script>
<script type="text/javascript">
var matchId=null;
var wrongIds="";
var isFirst=true;
function firstMatch(id) {
	if(isFirst){
		matchId=id;
		isFirst=false;
	}else{
		if(matchId==id){
			var secondId=id+10;
			//button disappear only in right answer
		}else{ 
			wrongIds+=matchId+",";
			document.getElementById("postData").value = wrongIds;
		}
		document.getElementById(matchId).style.visibility = 'hidden';
		document.getElementById(secondId).style.visibility = 'hidden';
		isFirst=true;
		matchId=null;
	}
}
function secondMatch(id){
	if(!isFirst){
		var secondId=id-10;
		if(secondId==matchId){
			//button disappear only in right answer
		}else{
			wrongIds+=matchId+",";
			document.getElementById("postData").value = wrongIds;
		}
		document.getElementById(matchId).style.visibility = 'hidden';
		document.getElementById(id).style.visibility = 'hidden';
		isFirst=true;
		matchId=null;
	}else{
		matchId=id-10;
		isFirst=false;
	}
}
function myClear(){
	wrongIds="";
	matchId=null;
	var isFirst=true;
    for (var i = 1; i <= 20; i++) { 
       document.getElementById(i).style.visibility = 'visible';
     }
}
</script>
<%
String topicId = null;
topicId = (String)request.getAttribute("topic_id");
String questionId = null;
questionId = (request.getAttribute("questionId")).toString();

ArrayList<Word> wordsRusKaz = (ArrayList<Word>)session.getAttribute("wordsRusKaz");

int j = Integer.parseInt(questionId);

%>
<br>

      <section id="main">
        <div class="question">
		<%
 if(j>=wordsRusKaz.size()){
		%>
			<div class="well" style="background-color:pink;" align="center">
			<h2>Список неверных слов: </h2>
			<%
				List<String> wrongWordsList=(List<String>) request.getAttribute("wrongWordsList");
				if(wrongWordsList.isEmpty()){
					%>
						<h3>нет</h3>
					<%
				}
				for(String wrongWord: wrongWordsList){
					%>
						<h3><%=wrongWord %></h3>
					<%
				}
			%>
			<br>
			<a href="?navPage=trainings&topic_id=<%=topicId%>" class = "btn btn-success">Закончить</a>
		   	</div>
		<%
	}
	else{		
		String width = "style='width:180px;'";
		List<Word> shuffleList=new ArrayList();
		List<Integer> pushedButtons=new ArrayList();
		shuffleList.addAll(wordsRusKaz);
		Collections.shuffle(shuffleList);
 %>
			<h1 class="text-center yellow">
            Подберите пару для каждого слова
          </h1>
 		<div class="row">
            <div class="col-sm-4 col-sm-offset-1">
			
			 <%
		 for(int i=0;i<shuffleList.size();i++){
    %>
		 		<button id=<%=shuffleList.get(i).id %> onclick="firstMatch(<%=shuffleList.get(i).id %>)" class="btn btn-success btn-block" <%=width %>><%=shuffleList.get(i).kaz %></button>
    			<h2></h2>
    <%
		 }
    %>
    		</div>
    		<div class="col-sm-4 col-sm-offset-3">   
			 <%
		 for(int i=0;i<shuffleList.size();i++){
			 wordsRusKaz.get(i).id=wordsRusKaz.get(i).id+10;
    %>
		 		<button id=<%=wordsRusKaz.get(i).id %> onclick="secondMatch(<%=wordsRusKaz.get(i).id %>)" class="btn btn-success btn-block" <%=width %>><%=wordsRusKaz.get(i).rus %></button>
    			<h2></h2>
    <%
		 }
			 
    %>
    </div>
    </div>
    <div class="row">
        <div class="col-sm-4 col-sm-offset-1">
        	<button onclick="myClear()" class="btn btn-answer" <%=width %>>Заново</button>       
        </div>
        <div class="col-sm-4 col-sm-offset-3">
			<form method="post" action="TrainingOneServlet" id="trainingOneForm">
			 <input type="hidden" name="topic_id" value="<%=topicId%>">
			 <input type="hidden" name="task_type" value="six">
			 <input type="hidden" name="page" value="trainingSixForm">
			 <input type="hidden" name="variant" id="postData" value="">
		     <button class="btn btn-answer" <%=width %>>Отправить</button>
	      	</form>
		</div>
    </div>
	 <%	
}
%>          
        </div>
        <div class="progress-holder">
          <div class="percent">
            <%=j*10 %>
          </div>
          <div class="progress">
            <div class="progress-bar" role="progressbar" aria-valuenow="<%=j*10 %>" aria-valuemin="0" aria-valuemax="100" style="width: <%=j*10 %>%;">
              <span class="sr-only">60%</span>
            </div>
          </div>
          <div class="clear"></div>
        </div>
      </section>
      
   