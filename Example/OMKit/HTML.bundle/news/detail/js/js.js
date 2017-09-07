// javascript

$(function() {
    FastClick.attach(document.body);
});


$(document).ready(function () {
    
    $(document.body).on("touchstart", function () {
    
    });
                  
    // 配置开发环境的基本参数。
    omApp.config({
        currentTheme: OMApp.Theme.day,
        currentUser: {
            id: "0",
            name: "Onemena",
            type: OMApp.UserType.google,
            coin: 0,
            token: "Onemena"
        },
        network: {
            type: OMApp.NetworkingType.other,
            ajaxSettings: {
                headers: {
                    "Access-Token": "OMApp",
                    "User-Token": "Onemena"
                },
                data: {}
            }
        },
        navigation: {
            bar: {
                title: "Onemena",
                titleColor: "#FFFFFF",
                backgroundColor: "#000000",
                isHidden: false
            }
        }
    });
    
    omApp.ready(function () {
         omApp.navigation.bar.isHidden = true;
         omHTML.more.list.reloadData();
         omHTML.hots.list.reloadData();
         omHTML.comments.list.reloadData();
    });
    
    
    
    // 以下代码中 App 环境中不执行。
    if (omApp.isInApp) {
        return;
    }
    
    /********************************/
    /*         自定义测试数据         */
    /********************************/
    
    var moreCount = Math.random() * 10;
    var hotsCount = Math.random() * 10;
    var commentsCount = Math.random() * 10;
    var floorCount = 0;
    
    omApp.delegate.numberOfRowsInList = function (documentName, listName, callback) {
        
        switch (listName) {
            case "More List":
                callback(parseInt(moreCount));
                moreCount += Math.random() * 10;
                break;
            case "Hot Comments List":
                callback(parseInt(hotsCount));
                break;
            case "Comments List":
                callback(parseInt(commentsCount));
                commentsCount += Math.random() * 10;
                break;
            case "Floor Comments List":
                callback( parseInt(floorCount) );
                floorCount += Math.random() * 5;
                break;
        }
        
    };
    
    var _aComment = " يا اخي حدثوا الاخبار الحمد لله تم تحرير بعشيقة وقيادة البشمركة في الإقليم أكد ذلك لإقليم أكد ذلك  يا اخي حدثوا الاخبار الحمد لله تم تحرير بعشيقة وقيادة البشمركة في الإقليم أكد ذلك لإقليم أكد ذلك  يا اخي حدثوا الاخبار الحمد لله تم تحرير بعشيقة وقيادة البشمركة في الإقليم أكد ذلك لإقليم أكد ذلك  يا اخي حدثوا الاخبار الحمد لله تم تحرير بعشيقة وقيادة البشمركة في الإقليم أكد ذلك لإقليم أكد ذلك  يا اخي حدثوا الاخبار الحمد لله تم تحرير بعشيقة وقيادة البشمركة في الإقليم أكد ذلك لإقليم أكد ذلك  يا اخي حدثوا الاخبار الحمد لله تم تحرير بعشيقة وقيادة البشمركة في الإقليم أكد ذلك لإقليم أكد ذلك ";
    
    omApp.delegate.dataForRowAtIndex = function (documentName, listName, index, callback) {
        switch (listName) {
            case "More List":
                callback({
                    id: index,
                    title: "News detail more news list " + index,
                    avatar: "http://src.mysada.com/shop/file/png/phpVMZjH9.png",
                    writer: {
                        name: "Onemena_" + index,
                        avatar: "http://src.mysada.com/shop/file/png/phpVMZjH9.png"
                    }
                });
                break;
            case "Hot Comments List":
            case "Comments List":
                callback({
                    id: index,
                    content: _aComment.substring(0, Math.random() * 400),
                    avatar: "http://src.mysada.com/shop/file/png/phpVMZjH9.png",
                    writer: {
                        name: index + "علاء الريحاني",
                        avatar: "http://src.mysada.com/shop/file/png/phpVMZjH9.png"
                    },
                    isLiked: false,
                    numberOfLikes: parseInt(Math.random() * 1000),
                    date: "قبل..دقيقة  ·",
                    numberOfReplies: index
                });
                break;
            case "Floor Comments List":
                callback({
                    id: index,
                    content: _aComment.substring(0, Math.random() * 400),
                    avatar: "http://src.mysada.com/shop/file/png/phpVMZjH9.png",
                    writer: {
                        name: index + "علاء الريحاني",
                        avatar: "http://src.mysada.com/shop/file/png/phpVMZjH9.png"
                    },
                    isLiked: false,
                    numberOfLikes: parseInt(Math.random() * 1000),
                    date: "قبل..دقيقة  ·",
                    numberOfReplies: "",
                    replyTo: {
                        user: {
                            name: "علاء"
                        },
                        content: "علاء الريحانيعلاء الريحانيعلاء الريحانيعلاء الريحاني"
                    }
                });
        }
    };
    
    omApp.delegate.cachedResourceForURL = function (url, resourceType, automaticallyDownload, callback) {
        callback(url);
    };
    
    
    var _selectedIndex = 0;
    
    omApp.delegate.didSelectRowAtIndex = function (documentName, listName, index, completion) {
        console.log("选择了 " + listName + " 的第 " + index + " 行。");
        if (typeof completion === 'function') {
            if (_selectedIndex !== index) {
                _selectedIndex = index;
                floorCount = 0;
            }
            setTimeout(completion, 1000);
        }
        
    };
    
    omApp.delegate.elementWasClicked = function (documentName, elementName, parameters, callback) {
        console.log(documentName + " 中的元素 " + elementName + " 被点击了：" + JSON.stringify(parameters));
        
        switch (elementName) {
            case "Comment Like":
                if (!!callback) {
                    callback(false)
                }
                break;
            case "Comments Load More":
            case "Floor Load More":
                setTimeout(function () {
                    callback();
                }, 1000);
                break;
            
            default:
                if (!!callback) {
                    if (typeof parameters === 'boolean') {
                        callback(!parameters);
                    } else if (typeof parameters["isSelected"] === 'boolean') {
                        callback(!parameters["isSelected"])
                    }
                    
                }
        }
        
    }
    

});

