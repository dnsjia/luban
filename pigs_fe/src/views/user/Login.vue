<template>
  <div>
    <div class="login_bg">
      <img src="../../assets/login_bg.jpg" />
      <div class="login">
<!--        <h3 style="z-index:1;text-align:center;"><img src="../../assets/logo.png" width="120" height="80"></h3>-->
        <br/>
        <h3 style="z-index:1;text-align:center;">小飞猪运维平台</h3>
        <br/>

        <a-tabs size="small">
          <a-tab-pane key="1" tab="帐号登录">
              <a-form ref="formRef" :model="formState" :rules="rules" :label-col="labelCol" :wrapper-col="wrapperCol">
                <a-form-item ref="email" name="email">
                  <a-input placeholder="邮箱" v-model:value="formState.email">
                    <template #prefix>
                      <user-outlined type="email" />
                    </template>
                  </a-input>
                </a-form-item>

                <a-form-item name="password">
                  <a-input-password placeholder="密码" v-model:value="formState.password">
                    <template #prefix>
                      <lock-outlined type="password" />
                    </template>
                  </a-input-password>
                </a-form-item>

                <a-form-item>
                    <a-checkbox v-model:checked="remember">
                        LDAP登录
                    </a-checkbox>
                    <a class="login-form-forgot" href="/user/forgotPwd">
                      忘记密码
                    </a>
                  <br/><br/>
                    <a-button type="primary" @click="onSubmit" class="login-form-button">登录</a-button>
                </a-form-item>
              </a-form>
          </a-tab-pane>

          <a-tab-pane key="2" tab="钉钉登录">
            <div id="login_container" class="login-container"></div>
          </a-tab-pane>

        </a-tabs>

      </div>
    </div>

  </div>
</template>

<script>
import { UserOutlined, LockOutlined } from '@ant-design/icons-vue';
import { defineComponent, reactive, ref, toRaw } from 'vue';
import { login } from '@/api/user'
export default defineComponent({
  name: "Login",
  setup() {
    const formRef = ref();
    const formState = reactive({
      email: '',
      password: '',
    });
    const rules = {
      email: [
        {
          required: true,
          message: '请输入帐号',
          trigger: 'blur',
        },
      ],
      password: [
        {
          required: true,
          message: '请输入密码',
          trigger: 'blur',
        },
      ],
    };

    const onSubmit = () => {
      formRef.value
        .validate()
        .then(() => {
          console.log('values', formState, toRaw(formState));
          console.log(formState.email)
          login().then(formState)


        })
        .catch(error => {
          console.log('error', error);
        });
    };
    return {
      formRef,
      labelCol: {
        span: 4,
      },
      wrapperCol: {
        span: 24,
      },
      formState,
      rules,
      onSubmit,
      remember: ref(false),
      widthVar: "0px",
    };
  },
  components: {
    UserOutlined,
    LockOutlined
  },
  // methods: {
  //   dcode(){
  //     dingConfig({}).then(_data => {
  //       const _this = this;
  //       const {errcode} = _data;
  //       const appId = _data.data.app_id
  //       // 后端返回的钉钉配置信息
  //       if (errcode === 0) {
  //         const _url = encodeURIComponent(this.$ENV.homeURL + '/user/login');
  //         const goto = encodeURIComponent('https://oapi.dingtalk.com/connect/oauth2/sns_authorize?appid=' + appId +
  //             '&response_type=code&scope=snsapi_login&state=STATE&redirect_uri=' + _url);
  //         const obj = DDLogin({
  //           id: "login_container",
  //           goto: goto,
  //           style: "border:none;background-color:#FFFFFF;",
  //           width: "310",
  //           height: "310"
  //         });
  //         const handleMessage = function (event) {
  //           const origin = event.origin;
  //           if (origin === "https://login.dingtalk.com") {
  //             const loginTmpCode = event.data;
  //             const url2 = 'https://oapi.dingtalk.com/connect/oauth2/sns_authorize?appid=' + appId +
  //                 '&response_type=code&scope=snsapi_login&state=STATE&redirect_uri=' +
  //                 _url + "&loginTmpCode=" + loginTmpCode;
  //             window.location.href = url2;
  //           }
  //         };
  //         if (typeof window.addEventListener !== 'undefined') {
  //           window.addEventListener('message', handleMessage, false);
  //         } else if (typeof window.attachEvent !== 'undefined') {
  //           window.attachEvent('onmessage', handleMessage);
  //         }
  //       }
  //       else {
  //         this.$msgerror("服务器钉钉配置错误")
  //       }
  //     });
  //     },
  //
  // },

})
</script>

<style scoped>
.login_bg {
    width: 100%;
    height: 900px;
    overflow: hidden;
    position: relative;
}
.login {
    position: absolute;
    top: 12%;
    left: 22%;
    -webkit-transform: translateX(-20%);
    transform: translateX(-70%);
    width: 370px;
    height: var(--widthVar);
    /*border: 1px solid #DCDFE6;*/
    margin: 150px auto;
    padding: 10px 20px 10px 20px;
    border-radius: 20px;
    box-shadow: 0 0 20px #DCDFE6;

}
/*.login-title {*/
/*    text-align: center;*/
/*    margin-bottom: 10px;*/
/*    position:absolute;*/
/*    z-index:1*/
/*}*/

.login-form-forgot {
    float: right;
}

.login-form-button {
    width: 100%;
}


</style>