"use strict";(self.webpackChunkmythic_laptop=self.webpackChunkmythic_laptop||[]).push([[6898,2262,9881,5760,3379,7024,7212,5697,4643,2738],{49488:(e,t,n)=>{n.r(t),n.d(t,{default:()=>B});var r=n(55429),a=n(15647),i=n(72857),o=n(1310),l=n(29506),c=n(42262),m=n(74268),u=n(40279),s=n(22785),d=n(90863),p=n(20500),y=n(44752),f=n(69796),b=n(59530),A=n(72839),h=n(37212),g=n(35697);function v(e){return v="function"==typeof Symbol&&"symbol"==typeof Symbol.iterator?function(e){return typeof e}:function(e){return e&&"function"==typeof Symbol&&e.constructor===Symbol&&e!==Symbol.prototype?"symbol":typeof e},v(e)}function E(e){return function(e){if(Array.isArray(e))return x(e)}(e)||function(e){if("undefined"!=typeof Symbol&&null!=e[Symbol.iterator]||null!=e["@@iterator"])return Array.from(e)}(e)||j(e)||function(){throw new TypeError("Invalid attempt to spread non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.")}()}function w(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function S(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?w(Object(n),!0).forEach((function(t){O(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):w(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function O(e,t,n){return(t=function(e){var t=function(e,t){if("object"!=v(e)||!e)return e;var n=e[Symbol.toPrimitive];if(void 0!==n){var r=n.call(e,t||"default");if("object"!=v(r))return r;throw new TypeError("@@toPrimitive must return a primitive value.")}return("string"===t?String:Number)(e)}(e,"string");return"symbol"==v(t)?t:t+""}(t))in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function P(e,t){return function(e){if(Array.isArray(e))return e}(e)||function(e,t){var n=null==e?null:"undefined"!=typeof Symbol&&e[Symbol.iterator]||e["@@iterator"];if(null!=n){var r,a,i,o,l=[],c=!0,m=!1;try{if(i=(n=n.call(e)).next,0===t){if(Object(n)!==n)return;c=!1}else for(;!(c=(r=i.call(n)).done)&&(l.push(r.value),l.length!==t);c=!0);}catch(e){m=!0,a=e}finally{try{if(!c&&null!=n.return&&(o=n.return(),Object(o)!==o))return}finally{if(m)throw a}}return l}}(e,t)||j(e,t)||function(){throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.")}()}function j(e,t){if(e){if("string"==typeof e)return x(e,t);var n={}.toString.call(e).slice(8,-1);return"Object"===n&&e.constructor&&(n=e.constructor.name),"Map"===n||"Set"===n?Array.from(e):"Arguments"===n||/^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)?x(e,t):void 0}}function x(e,t){(null==t||t>e.length)&&(t=e.length);for(var n=0,r=Array(t);n<t;n++)r[n]=e[n];return r}var C=(0,i.A)((function(e){return{wrapper:{height:"100%",background:e.palette.secondary.main},content:{height:"100%",overflow:"hidden"},headerAction:{},emptyMsg:{width:"100%",textAlign:"center",fontSize:20,fontWeight:"bold",marginTop:"25%"},tabPanel:{top:0,height:"93.25%"},list:{height:"100%",overflow:"auto"},upper:{height:"10%",textAlign:"center",position:"relative"},lower:{height:"90%",padding:8},orderBtn:{position:"absolute",height:45,width:"fit-content",top:0,bottom:0,left:0,right:0,margin:"auto"},col:{paddingRight:14,"& h3":{borderBottom:"1px solid ".concat(e.palette.border.divider),paddingBottom:6},"&:not(:last-of-type)":{borderRight:"1px solid ".concat(e.palette.border.divider)}},header:{fontSize:16,"& small":{fontSize:12,color:e.palette.text.alt},"& svg":{fontSize:14}}}})),N={rubber:2e3,plastic:2e3,electronic_parts:2e3,copperwire:2e3,glue:2e3,heavy_glue:2e3,ironbar:700,silverbar:120,goldbar:70},k={tier:1,paymentCoin:"PLEB",paymentAmount:0,items:Array()},T={item:"",amount:1e3};const B=function(e){var t=C(),n=(0,a.wA)(),i=(0,a.d4)((function(e){return e.data.data.items})),v=(0,a.d4)((function(e){return e.data.data.activeOrders})),w=(0,a.d4)((function(e){return e.data.data.pastOrders})),j=(0,a.d4)((function(e){return e.data.data.activeTeams})),x=P((0,r.useState)(!1),2),B=x[0],I=(x[1],P((0,r.useState)(!1),2)),D=I[0],L=I[1],M=P((0,r.useState)(!1),2),_=M[0],W=M[1],R=P((0,r.useState)(S({},k)),2),$=R[0],z=R[1],F=P((0,r.useState)(S({},T)),2),Y=F[0],q=F[1],U=function(e){z(S(S({},$),{},O({},e.target.name,e.target.value)))};return r.createElement("div",{className:t.wrapper},r.createElement(o.Ay,{container:!0,className:t.upper},r.createElement(l.A,{className:t.orderBtn,variant:"contained",onClick:function(){return L(!0)}},"Submit New Order")),r.createElement(o.Ay,{container:!0,spacing:2,className:t.lower},r.createElement(o.Ay,{item:!0,xs:4,className:t.col},r.createElement("h3",null,"Your Active Orders"),r.createElement(c.A,null,v.length>0?v.sort((function(e,t){return t.date-e.date})).map((function(e){return r.createElement(h.default,{key:"order-".concat(e._id),order:e})})):r.createElement(m.Ay,{divider:!0},r.createElement(u.A,{primary:"No Active Orders"})))),r.createElement(o.Ay,{item:!0,xs:4,className:t.col},r.createElement("h3",null,"Your Past Orders"),r.createElement(c.A,null,w.length>0?w.sort((function(e,t){return t.date-e.date})).map((function(e){return r.createElement(h.default,{key:"order-".concat(e._id),order:e})})):r.createElement(m.Ay,{divider:!0},r.createElement(u.A,{primary:"No Past Orders"})))),r.createElement(o.Ay,{item:!0,xs:4,className:t.col},r.createElement("h3",null,"Available Teams"),r.createElement(c.A,null,j.length>0?j.map((function(e){return r.createElement(g.default,{key:"team-".concat(e._id),team:e})})):r.createElement(m.Ay,{divider:!0},r.createElement(u.A,{primary:"No Active Teams"}))))),r.createElement(A.aF,{open:D,title:"Submit New Order",submitLang:"Submit",onSubmit:function(e){e.preventDefault(),n({type:"ADD_DATA",payload:{id:"activeOrders",data:{_id:v.length,tier:$.tier,date:Date.now()/1e3,items:$.items,payment:{coin:$.paymentCoin,amount:$.paymentAmount}}}}),L(!1),z(S({},k))},onClose:function(){L(!1),z(S({},k)),W(!1),q(S({},T))}},r.createElement(o.Ay,{container:!0,spacing:2},r.createElement(o.Ay,{item:!0,xs:12},r.createElement(s.A,{fullWidth:!0,select:!0,name:"tier",label:"Tier",onChange:U,value:$.tier},E(Array(5).keys()).map((function(e){return r.createElement(d.A,{key:"tier-".concat(e),value:e+1},e+1)})))),r.createElement(o.Ay,{item:!0,xs:2},r.createElement(s.A,{fullWidth:!0,select:!0,name:"paymentCoin",label:"Coin",onChange:U,value:$.paymentCoin},r.createElement(d.A,{value:"PLEB"},"Plebian"))),r.createElement(o.Ay,{item:!0,xs:5},r.createElement(s.A,{disabled:!0,fullWidth:!0,label:"Base Cost",value:"".concat(100*$.tier," $").concat($.paymentCoin)})),r.createElement(o.Ay,{item:!0,xs:5},r.createElement(f.A,{fullWidth:!0,required:!0,name:"paymentAmount",label:"Bonus Payment",value:$.paymentAmount,disabled:B,onChange:function(e){return z(S(S({},$),{},{paymentAmount:+e.target.value}))},type:"tel",isNumericString:!0,customInput:s.A})),r.createElement(o.Ay,{item:!0,xs:12},r.createElement(s.A,{disabled:!0,fullWidth:!0,label:"Fee",value:"".concat(20*$.tier," $").concat($.paymentCoin)})),r.createElement(o.Ay,{item:!0,xs:12},r.createElement(s.A,{disabled:!0,fullWidth:!0,label:"Total Cost",value:"".concat(100*$.tier+20*$.tier+$.paymentAmount," $").concat($.paymentCoin)})),r.createElement(o.Ay,{item:!0,xs:12},r.createElement("h3",{className:t.header},"Items"," ",r.createElement("small",null,2*$.tier-$.items.length," ","Slots Available"),2*$.tier-$.items.length>0&&r.createElement(p.A,{onClick:function(){return W(!0)}},r.createElement(b.g,{icon:["fas","plus"]}))),r.createElement(c.A,{dense:!0},$.items.map((function(e,t){var n=i[e.item];return Boolean(n)?r.createElement(m.Ay,{divider:!0,key:"orderitem-".concat(t)},r.createElement(u.A,{primary:n.label,secondary:e.amount}),r.createElement(y.A,null,r.createElement(p.A,{onClick:function(){return e=t,void z(S(S({},$),{},{items:$.items.filter((function(t,n){return n!=e}))}));var e}},r.createElement(b.g,{icon:["fas","trash"]})))):null})))))),_&&D&&r.createElement(A.aF,{maxWidth:"sm",open:_,title:"Add Item To Order",submitLang:"Add",onSubmit:function(e){e.preventDefault(),z(S(S({},$),{},{items:[].concat(E($.items),[Y])})),W(!1),q(S({},T))},onClose:function(){W(!1),q(S({},T))}},r.createElement(o.Ay,{container:!0,spacing:2},r.createElement(o.Ay,{item:!0,xs:12},r.createElement(s.A,{fullWidth:!0,select:!0,name:"item",label:"Item",onChange:function(e){q(S(S({},Y),{},O(O({},e.target.name,e.target.value),"amount",N[e.target.value])))},value:Y.item},Object.keys(N).map((function(e){var t=i[e];return r.createElement(d.A,{key:"item-".concat(e),value:e},t.label," - Amount:"," ",N[e])})))))))}},37212:(e,t,n)=>{n.r(t),n.d(t,{default:()=>s});var r=n(55429),a=n(15647),i=n(72857),o=n(74268),l=n(40279),c=(n(59530),n(51698)),m=n.n(c),u=(0,i.A)((function(e){return{wrapper:{height:"100%",background:e.palette.secondary.main}}}));const s=function(e){var t=e.order,n=u();(0,a.d4)((function(e){return e.data.data.items}));return r.createElement(o.Ay,{divider:!0,className:n.wrapper},r.createElement(l.A,{style:{width:Boolean(t.team)?"25%":"33.333%"},primary:"Date",secondary:r.createElement(m(),{format:"L",date:t.date,unix:!0})}),r.createElement(l.A,{style:{width:Boolean(t.team)?"25%":"33.333%"},primary:"Tier",secondary:t.tier}),r.createElement(l.A,{style:{width:Boolean(t.team)?"25%":"33.333%"},primary:"Payment",secondary:r.createElement("span",null,t.payment.amount," $",t.payment.coin)}),Boolean(t.team)&&r.createElement(l.A,{style:{width:"25%"},primary:"Team",secondary:t.team.name}))}},35697:(e,t,n)=>{n.r(t),n.d(t,{default:()=>m});var r=n(55429),a=n(15647),i=n(72857),o=n(74268),l=n(40279),c=(n(59530),n(51698),(0,i.A)((function(e){return{wrapper:{height:"100%",background:e.palette.secondary.main}}})));const m=function(e){var t=e.team,n=c();(0,a.d4)((function(e){return e.data.data.items}));return r.createElement(o.Ay,{divider:!0,className:n.wrapper},r.createElement(l.A,{primary:"Team #",secondary:t._id}),r.createElement(l.A,{primary:"Team Name",secondary:t.name}),r.createElement(l.A,{primary:"Members",secondary:r.createElement("span",null,t.members.length," Members")}))}},89883:(e,t,n)=>{n.d(t,{A:()=>o,f:()=>i});var r=n(52679),a=n(95478);function i(e){return(0,a.Ay)("MuiListItemIcon",e)}const o=(0,r.A)("MuiListItemIcon",["root","alignItemsFlexStart"])},42262:(e,t,n)=>{n.d(t,{A:()=>A});var r=n(86887),a=n(64180),i=n(55429),o=n(34164),l=n(7413),c=n(23805),m=n(29115),u=n(74024),s=n(52679),d=n(95478);function p(e){return(0,d.Ay)("MuiList",e)}(0,s.A)("MuiList",["root","padding","dense","subheader"]);var y=n(64922);const f=["children","className","component","dense","disablePadding","subheader"],b=(0,c.Ay)("ul",{name:"MuiList",slot:"Root",overridesResolver:(e,t)=>{const{ownerState:n}=e;return[t.root,!n.disablePadding&&t.padding,n.dense&&t.dense,n.subheader&&t.subheader]}})((({ownerState:e})=>(0,a.A)({listStyle:"none",margin:0,padding:0,position:"relative"},!e.disablePadding&&{paddingTop:8,paddingBottom:8},e.subheader&&{paddingTop:0}))),A=i.forwardRef((function(e,t){const n=(0,m.b)({props:e,name:"MuiList"}),{children:c,className:s,component:d="ul",dense:A=!1,disablePadding:h=!1,subheader:g}=n,v=(0,r.A)(n,f),E=i.useMemo((()=>({dense:A})),[A]),w=(0,a.A)({},n,{component:d,dense:A,disablePadding:h}),S=(e=>{const{classes:t,disablePadding:n,dense:r,subheader:a}=e,i={root:["root",!n&&"padding",r&&"dense",a&&"subheader"]};return(0,l.A)(i,p,t)})(w);return(0,y.jsx)(u.A.Provider,{value:E,children:(0,y.jsxs)(b,(0,a.A)({as:d,className:(0,o.A)(S.root,s),ref:t,ownerState:w},v,{children:[g,c]}))})}))}}]);