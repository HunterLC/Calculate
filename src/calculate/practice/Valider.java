package calculate.practice;
import com.opensymphony.xwork2.ActionSupport;
import org.apache.struts2.interceptor.SessionAware;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import static com.opensymphony.xwork2.Action.SUCCESS;

public class Valider extends ActionSupport implements SessionAware {
    private String sid;
    private Map session;
    private String answer;
    private String counter;
    private InputStream inputStream;

    public InputStream getInputStream() {
        return inputStream;
    }

    public String getAnswer() {
        return answer;
    }

    public void setAnswer(String answer) {
        this.answer = answer;
    }
    public String getCounter() {
        return counter;
    }

    public void setCounter(String counter) {
        this.counter = counter;
    }

    public String getSid() {
        return sid;
    }
    public void setSid(String sid) {
        this.sid = sid;
    }
    @Override
    public void setSession(Map<String, Object> session) {
        this.session = session;
    }

    public String valid() throws Exception {
        ArrayList history = (ArrayList)session.get(sid);
        HashMap turn = (HashMap) history.get(history.size() - 1);
        //设置答题时间
        turn.put("expire_time",counter);
        System.out.println("答题耗时:"+counter);
        // 对比答案是否正确
        String standard_answer = turn.get("answer").toString();
        System.out.println("用户答案为:" + answer + "，标准答案为:" + standard_answer);
        String result = "wrong";
        if (answer.equals(standard_answer)) {
            result = "right";
            turn.put("result",true);
        }
        inputStream = new ByteArrayInputStream(result.getBytes(StandardCharsets.UTF_8));
        return SUCCESS;
    }

    public String getTotalTime() throws Exception{
        ArrayList history = (ArrayList)session.get(sid);
        int countTime = 0;//答题时间
        int countRight = 0;//答题正确数
        for(int i = 0;i < history.size()-1;i++){
            HashMap turn = (HashMap) history.get(i);
            countTime = countTime + Integer.valueOf(String.valueOf(turn.get("expire_time"))); //累加答题时间
            if(turn.get("result").toString().equals("true"))
                countRight++;
        }
        String count_Char = "总共答题"+(history.size()-1)+ "道,正确答题数目"+  countRight + "道,答题时间"+String.valueOf(countTime);
        inputStream = new ByteArrayInputStream(count_Char.getBytes(StandardCharsets.UTF_8));
        return SUCCESS;
    }

    public String setTimeOutCounter() throws Exception{
        ArrayList history = (ArrayList)session.get(sid);
        HashMap turn = (HashMap) history.get(history.size()-1);
        turn.put("expire_time",counter);
        return SUCCESS;
    }


}
