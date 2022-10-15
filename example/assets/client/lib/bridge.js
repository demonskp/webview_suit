
function sendMsg(package="", method="", data="", successCb, errCb) {

  const funid = new Date().getTime()+'' || "111";
  window.__myJsBridge__.postMessage(JSON.stringify({package, method, data:JSON.stringify(data), funid}));

  const success = successCb || function(){};
  const err = errCb || function(){};


  window.__myJsBridge__[funid] = {
    success,
    err,
  }
}

function promiseWrap() {

}

const bridge = {
  _ready: false,
  callStack: [],

  sendMsg: (package="", method="", data={}, success, fail) => {
    const funid = new Date().getTime()+'' || "111";
    window.__myJsBridge__.postMessage(JSON.stringify({package, method, data, funid}));
  
    const successCb = success || function(){};
    const failCb = fail || function(){};
  
  
    window.__myJsBridge__[funid] = {
      successCb,
      failCb,
    }
  },
  print: (text) => {
    return new Promise((resolve, reject) => {
      this.sendMsg("self", "print", { text }, resolve, reject);
    })
  },
}

window.bridge = bridge;
