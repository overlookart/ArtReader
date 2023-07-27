// ==UserScript==
//@name 阅读工具
!function(){
    window.__reader__ || Object.defineProperty(window, "__reader__", {
        configurable: false,
        enumerable: false,
        writable: false,
        value:{
            enableNight: true,
            //字体大小 Class 集合
            fontSizeClasses:['textSizeOne','textSizeTwo','textSizeThree','textSizeFour','textSizeFive'],
            
            fontSize: 0,
            //切换夜间模式
            toggleNightMode: function(){
                this.enableNight = !this.enableNight;
                this.updateNightMode()
            },

            //更改字体大小
            changeFontSize: function(size){
                this.fontSize = size;
                this.updateFontSize();
            },
            //Element 是否有 Class
            hasClass: function(ele,cls) {
                return !!ele.className.match(new RegExp('(\\s|^)'+cls+'(\\s|$)'));
            },
            
            //为 Element 添加 class
            addClass: function(ele,cls) {
                if(!this.hasClass(ele,cls)){
                    ele.className += " "+cls;
                }
            },
            
            //为 Element 移除 class
            removeClass: function (ele,cls) {
              if (this.hasClass(ele,cls)) {
                var reg = new RegExp('(\\s|^)'+cls+'(\\s|$)');
                ele.className=ele.className.replace(reg,' ');
              }
            },
            
            //更新夜间模式
            updateNightMode: function(){
                var elm = document.documentElement;
                if(this.enableNight) {
                    this.addClass(elm, "nightMode");
                } else {
                    this.removeClass(elm, "nightMode");
                }
            },
            
            //更新字体大小
            updateFontSize: function () {
                let fontSizeClass = this.fontSizeClasses[this.fontSize];
                var elm = document.documentElement;
                this.fontSizeClasses.forEach(item => {
                    this.removeClass(elm, item);
                })
                this.addClass(elm, fontSizeClass);
            }
        }
    });

    __reader__.updateNightMode();
    __reader__.updateFontSize();
}();
