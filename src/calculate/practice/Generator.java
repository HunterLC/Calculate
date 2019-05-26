package calculate.practice;
import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Map;
import static com.opensymphony.xwork2.Action.SUCCESS;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;
import org.apache.struts2.interceptor.SessionAware;

public class Generator extends ActionSupport implements SessionAware {
    private InputStream inputStream;
    private String sid;

    private Map session;

    public String getSid() {
        return sid;
    }

    public void setSid(String sid) {
        this.sid = sid;
    }

    public InputStream getInputStream() {
        return inputStream;
    }

    private int getRandomNumber(int low, int hi) {
        return (int)(Math.random() * (hi - low)) + low;
    }

    private String getRandomOperation() {
        String[] operations = {"+", "-", "×", "÷"};
        return operations[(int)(Math.random()*4)];
    }

    public String execute() throws Exception {
        // 记录用户session id
        // 随机生成算式并返回，格式为"num1,operation,num2"
        int a = getRandomNumber(0, 100);
        int b = getRandomNumber(0, 100);
        String operation = getRandomOperation();
        String result = a + "," + operation + "," + b;
        inputStream = new ByteArrayInputStream(result.getBytes(StandardCharsets.UTF_8));
        // 实现计算答案，并保存
        int ans = getAnswer(a, b, operation);
        setSession(ans);
        return SUCCESS;
    }

    private int getAnswer(int a, int b, String operation) {
        int ans = 0;
        switch (operation) {
            case "+": ans = a + b; break;
            case "-": ans = a - b; break;
            case "×": ans = a * b; break;
            case "÷": ans = a / b; break;
        }
        return ans;
    }

    private void setSession(int answer) {
        System.out.println("sid = " + sid);
        if (!session.containsKey(sid)) {
            session.put(sid, new ArrayList<Object>());
        }

        ArrayList history = (ArrayList)session.get(sid);
        HashMap turn = new HashMap<String, Object>();
        turn.put("epoch", history.size());
        turn.put("answer", answer);
        turn.put("result",false);
        turn.put("expire_time", 0); //暂时不设置答题时间
        history.add(turn);

        System.out.println("epoch = " + (history.size() - 1));
        System.out.println("answer = " + answer);

        session.put(sid, history);
    }

    @Override
    public void setSession(Map<String, Object> session) {
        this.session = session;
    }
}
