import { createStore } from 'vuex'


const store =  createStore({
  state: {
    changeNetwork: true //是否断网
  },
  mutations: {
    changeNetwork(state,val){ //改变状态
      state.changeNetwork = val
    }
  },
  actions: {

  }
})

export default store