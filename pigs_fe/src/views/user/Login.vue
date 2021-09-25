<template>
    <div class="login_bg">
<!--      <img src="../../assets/login_bg.jpg" />-->
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
                    <a-checkbox v-model:checked="formState.ldap_enable">
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
</template>

<script>
// import { message } from 'ant-design-vue';
import { UserOutlined, LockOutlined } from '@ant-design/icons-vue';
import { defineComponent, reactive, ref, inject } from 'vue';
import { useCookie } from 'vue-cookie-next'
import { login } from '@/api/user'
import router from "../../router";
export default defineComponent({
  name: "Login",
  // const { inject } = Vue;
  setup() {
    const formRef = ref();
    const formState = reactive({
      email: '',
      password: '',
      ldap_enable: false
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
    const { setCookie } = useCookie()
    const onSubmit = () => {
      formRef.value
        .validate()
        .then(() => {
          login({
            "email": formState.email,
            "password": formState.password,
            "ldap_enable": formState.ldap_enable,
          }).then(res => {
            if (res.errCode === 0) {
              setCookie('email',res.data.email)
              setCookie("token", res.data.token, {expire: '1d', path: '/', domain: ''}) // 24小时过期
              setCookie('username', res.data.username)
              localStorage.setItem("onLine", 1)
              message.success("登录成功")
              router.push("/")
            }else {
              message.warning(res.errMsg)
            }
          })
        })
        .catch(error => {
          console.log('error', error);
        });
    };

    const message = inject('$message');

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
      // ldap_enable: ref(false),
      widthVar: "0px",

      // warning,
      // success,
    };
  },
  components: {
    UserOutlined,
    LockOutlined
  },

})
</script>

<style scoped>
.login_bg {
  width: 100%;
  height: 100%;
  background: url("../../assets/login_bg.jpg") no-repeat;
  /*background-size: 100% 100%;*/
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