package org.devio.flutter.hybrid;

import android.app.Activity;
import android.content.Context;
import android.support.annotation.NonNull;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.RadioGroup;
import android.widget.TextView;

/**
 * Flutter Native通信 | 混合开发
 * Author: CrazyCodeBoy
 * 技术博文：http://www.devio.org
 * GitHub:https://github.com/crazycodeboy
 * Email:crazycodeboy@gmail.com
 */
public class UIPresenter implements View.OnClickListener {
    private final IShowMessage iShowMessage;
    Activity activity;
    TextView textShow;
    EditText input;
    String title;
    boolean useEventChannel;
    public UIPresenter(@NonNull Activity activity, String title, IShowMessage iShowMessage) {
        this.activity = activity;
        this.title = title;
        this.iShowMessage = iShowMessage;
        initUI();
    }

    private void initUI() {
        ViewGroup contentView = activity.findViewById(android.R.id.content);
        View view = LayoutInflater.from(activity).inflate(R.layout.item_container, null);
        ViewGroup.LayoutParams layoutParams =
            new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        contentView.addView(view, layoutParams);
        textShow = view.findViewById(R.id.textShow);
        input = view.findViewById(R.id.input);
        TextView titleView = view.findViewById(R.id.title);
        titleView.setText(title);
        view.findViewById(R.id.btnSend).setOnClickListener(this);
        RadioGroup radioGroup = view.findViewById(R.id.radioGroup);
        radioGroup.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup group, int checkedId) {
                if (checkedId == R.id.mode_basic_message_channel) {
                    useEventChannel = false;
                } else if (checkedId == R.id.mode_event_channel) {
                    useEventChannel = true;
                }
            }
        });
        input.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {
                iShowMessage.sendMessage(charSequence.toString(),useEventChannel);
            }

            @Override
            public void afterTextChanged(Editable editable) {

            }
        });
    }

    public void showDartMessage(String message) {
        textShow.setText("收到Dart消息:" + message);
    }

    @Override
    public void onClick(View v) {
        int id = v.getId();
        if (id == R.id.btnSend) {
            InputMethodManager imm = (InputMethodManager) activity.getSystemService(Context.INPUT_METHOD_SERVICE);
            //隐藏软键盘
            imm.hideSoftInputFromWindow(input.getWindowToken(), 0);

            String data = input.getText().toString();
            //            sendEvent(data);
        }
    }
}
