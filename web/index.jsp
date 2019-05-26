<%--
  Created by IntelliJ IDEA.
  User: nikoyou
  Date: 2019-05-24
  Time: 22:41
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>四则运算练习</title>
  <style>
    .center_box {
       position: relative;
       top: 12%;
       left: 35%;
       width: 600px;
       height: 100px;
     }
    .operate_box {
      position: relative;
      top: 12%;
      left: 35%;
      width: 600px;
      height: 100px;
    }
    .number {
      font-size: 36;
      color: dodgerblue;
      font-family: "Microsoft YaHei", "微软雅黑", STXihei, "华文细黑", Georgia, "Times New Roman", serif;
      float: left;
      margin: 12px;
    }
    .operation {
      font-size: 42;
      color: rgb(247, 38, 66);
      font-family: "Microsoft YaHei", "微软雅黑", STXihei, "华文细黑", Georgia, "Times New Roman", serif;
      float: left;
      margin: 12px;
    }
    .equal {
      font-size: 42;
      color: rgb(14, 13, 13);
      font-family: "Microsoft YaHei", "微软雅黑", STXihei, "华文细黑", Georgia, "Times New Roman", serif;
      float: left;
      margin: 12px;
    }
    .answer {
      height: 68px;
      width: 200px;
      border-radius:10px;
      font-size: 20px;
      outline: none;

      padding-left: 22px;
      padding-right: 22px;

      border: 0px;

      float: left;

      margin: 5px 0px 0px 10px;
    }
    .submit-button {
      width: 100px;
      height: 40px;
      border-width: 0px;
      border-radius: 3px;
      background: #1E90FF;
      cursor: pointer;
      outline: none;
      font-family: Microsoft YaHei;
      color: white;
      font-size: 17px;
      margin: 12px;
    }
    .submit-button:hover {
      background: #5599FF;
    }
    .stop-button {
      width: 100px;
      height: 40px;
      border-width: 0px;
      border-radius: 3px;
      background: #1E90FF;
      cursor: pointer;
      outline: none;
      font-family: Microsoft YaHei;
      color: white;
      font-size: 17px;
      margin: 24px;
    }
    .stop-button:hover {
      background: #5599FF;
    }
    .timenumber {
      font-size: 36;
      color: red;
      font-family: "Microsoft YaHei", "微软雅黑", STXihei, "华文细黑", Georgia, "Times New Roman", serif;
    }
  </style>
</head>
<body>
<h3 style="text-align:center;">程序是一个四则运算小程序网页，单击提交答案按钮，答案提交后进行验证，返回正/误结果后刷新新的算式</h3>
<p style="text-align:center;">除法运算采用向下取整运算，例如 5÷2 的答案是 2，而非 2.5</p>
<p style="text-align:center;">10秒内不提交答案，视为答案有误,按下 <b>结束</b> 停止计时</p>
<form name="timeForm"  style="text-align:center;">
  本题已经耗时：<input type="text" name="input1" class="timenumber" size="2" readonly="readonly" style="border-style:none">
  <BR>
</form>
<div class="center_box">
  <div>
    <div id="num1" class="number"></div>
    <div id="operation" class="operation"></div>
    <div id="num2" class="number"></div>
    <div class="equal">=</div>
    <input id="answer" class="answer" type="text" placeholder="请输入答案" />
  </div>
</div>
<div class="operate_box">
  <div>
    <button id="submit_btn" class="submit-button">提交</button>
    <button id="stop_btn" class="stop-button">结束</button>
  </div>
</div>
</body>
<!--jQuery百度镜像-->
<script src="https://apps.bdimg.com/libs/jquery/2.1.4/jquery.min.js"></script>
<script language="JavaScript">
  var counter = 0;
  var ID = window.setTimeout("timeTicher();",1000);
  function timeTicher(){
    counter++;
    window.status="本题已经耗时："+ counter;
    document.timeForm.input1.value=counter;
    if(counter>=10){
      $.get(
              "setTimeOut?sid=" + sid +"&counter=" + 10
      )
      alert("已经超时了，只能进行下一道题了（当然这道题算你做错了）");
      $("#answer").val("");
      getProblem();
      $("#answer").focus();
      counter = 0;
      ID = window.setTimeout("JavaScript:timeTicher();",1000);
    }
    else
      ID = window.setTimeout("JavaScript:timeTicher();",1000);
  }
</script>

<script>
  sid = "fortest";
  getProblem();
  $("#answer").focus();

  function getProblem() {
    $.get(
            "problem?sid="+sid,
            function(response) {
              var words = response.split(",");
              $("#num1").html(words[0]);
              $("#operation").html(words[1]);
              $("#num2").html(words[2]);
            }
    )
  }

  $("#submit_btn").on("click", validAnswer);

  function validAnswer() {
    answer = $("#answer").val();
    $.get(
            "valid?sid=" + sid + "&answer=" + answer + "&counter=" + counter, //传入用户答题时间
            function (response) {
              if (response == "right") {
                alert("答对了，你可真是个小机灵鬼！");
              } else {
                alert("答错了哦小可怜。。。");
              }
              $("#answer").val("");
              getProblem();
              $("#answer").focus();
              counter = 0;
            }
    );
  }

  $("#stop_btn").on("click", stopRunning);
  function stopRunning(){
    $.get(
            "getTotal?sid=" + sid,
            function (response) {
              alert(response)
            }
    );
    counter = 0;
    window.clearTimeout(ID);
  }

  document.onkeydown = function(event) {
    var e = event || window.event || arguments.callee.caller.arguments[0];
    if (e && e.keyCode == 13) {
      $('#submit_btn').click();
    }
  }

</script>
</html>