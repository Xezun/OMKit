// The JQuery selector.
var _OMSEL = {
    title: "div.main .header .title",
    writer: {
        avatar: "div.main .header .infoBar .right .writer .avatar",
        name: "div.main .header .infoBar .right .writer .name"
    },
    follow: "div.main .header .infoBar .left .follow",
    date: "div.main .header .infoBar .right .date",
    content: "div.main .body .content",
    contentImage: "div.main .body .content img",
    link: "div.main .body .link a",
    
    actionsDiv: "div.main .footer .actions",
    actionsLike: "div.main .footer .actions a.like",
    actionsLikeText: "div.main .footer .actions a.like .text",
    actionsDislike: "div.main .footer .actions a.dislike",
    actionsDislikeText: "div.main .footer .actions a.dislike .text",
    actionsReport: "div.main .footer .actions a.report",
    
    shareTitle: "div.main .footer .share .title .text",
    sharePlatforms: "div.main .footer .share .list .platforms",
    sharePlatformItem: "div.main .footer .share .list .platforms a",
    
    more: "div.main .footer .more",
    moreTitle: "div.main .footer .more .title .text",
    moreList: "div.main .footer .more .list",
    moreListItem: "div.main .footer .more .list>.item",
    moreListItemFist: "div.main .footer .more .list>.item:eq(0)",
    moreListItem_find_Title: ">div.title",
    moreListItem_find_Avatar: ">img.avatar",
    moreListItem_find_WriterAvatar: ">div.toolBar div.writer.info img.avatar.icon",
    moreListItem_find_WriterName: ">div.toolBar div.writer.info span.name.text",
    
    hots: "div.main .footer .hots.comments",
    hotsTitle: "div.main .footer .hots.comments .title .text",
    hotsList: "div.main .footer .hots.comments .list",
    hotsListItem: "div.main .footer .hots.comments .list>.item",
    
    comments: "div.main .footer .normal.comments",
    commentsTitle: "div.main .footer .normal.comments .title .text",
    commentsList: "div.main .footer .normal.comments .list",
    
    commentsListItem: "div.main .footer .comments .list>.item",
    
    
    commentsListItem_find_WriterAvatar: ".infoBar .writer img.avatar",
    commentsListItem_find_WriterName: ".infoBar .writer a.name",
    commentsListItem_find_Like: ".infoBar .like",
    commentsListItem_find_LikeText: ".infoBar .like span.text",
    commentsListItem_find_Content: ">div.content",
    commentsListItem_find_Date: ">div.toolBar span.date",
    commentsListItem_find_Reply: ">div.toolBar a.reply",
    commentsListItem_find_ReplyNumber: ">div.toolBar a.reply .number",
    
    commentsListItem_find_ReplyTo: ">div.replyTo",
    commentsListItem_find_ReplyToUserName: ">div.replyTo .user .name",
    commentsListItem_find_ReplyToContent: ">div.replyTo .content",
    
    loading: "div.main>.loading",
    loadingIcon: "div.main>.loading>.icon",
    loadingText: "div.main>.loading>.text",
    loadingEmpty: "div.main>.loading>.empty",
    
    floor: "body>.floor",
    floorClose: "body>.floor .header .bar .close",
    floorHeader: "body>div.floor .header",
    floorTitle: "body>div.floor .header .bar .text",
    floorComments: "body>div.floor .comments",
    floorList: "body>div.floor .comments .list",
    floorListItem: "body>div.floor .comments .list>.item",
    floorHost: "body>div.floor .comments>.title>.host",
    
    floorLoading: "body>div.floor .comments>.loading",
    floorLoadingIcon: "body>div.floor .comments>.loading>.icon",
    floorLoadingText: "body>div.floor .comments>.loading>.text",
    floorLoadingEmpty: "body>div.floor .comments>.loading>.empty",
    
    toolBar: "body>.toolBar",
    toolBarInput: "body>.toolBar a.input",
    toolBarComment: "body>.toolBar a.comment",
    toolBarNumberOfComments: "body>.toolBar a.comment .text",
    toolBarCollect: "body>.toolBar a.collect",
    toolBarShare: "body>.toolBar a.share",
    
    textInputMask: "body>.textInputMask",
    
    textInputDiv: "body>.toolBar .textInput",
    textInputForm: "body>.toolBar .textInput form",
    textInputTextArea: "body>.toolBar .textInput .input textarea",
    textInputSubmit: "body>.toolBar .textInput .submit input",
    textInputNumberOfWords: "body>.toolBar .textInput .submit .numberOfWords",
    
    
    navBack: "body>.nav .bar .back",
    navClose: "body>.nav .bar .close",
    navInfo: "body>.nav .bar .info"
};

// The resource url.
var _OMURL = {
    newsAvatar:{
        src: "image/avatar_news.png",
        srcset: "image/avatar_news@2x.png 2x, image/avatar_news@3x.png 3x"
    }
};

var _OMListLoadingState = {
    empty: "empty",
    idle: "idle",
    loading: "loading",
    noMoreData: "noMoreData"
};

// omHTML
(function () {
    var _omHTML = new XZExtendable();
    Object.defineProperty(window, "omHTML", {
        get: function () {
            return _omHTML;
        }
    });
})();

// omHTML.ready, omHTML.documentIsReady
omHTML.defineProperties(function () {
    var _readyHandlers = [];
    function _ready(callback) {
        _readyHandlers.push(callback);
    }
    
    // 调用此方法以启动 omHTML
    function _documentIsReady() {
        while (_readyHandlers.length > 0) {
            var handler = _readyHandlers.shift();
            if (typeof handler === 'function') {
                handler.call(this);
            }
        }
    }
    
    return {
        ready: { get: function () { return _ready; } },
        documentIsReady: { get: function () { return _documentIsReady; } }
    }
});


// omHTML.name
omHTML.ready(function () {
    this.defineProperty('name', function () {
        return {
            get: function () {
                return "News Detail";
            }
        };
    });
});

// omHTML.title
omHTML.ready(function () {
    this.defineProperty('title', function () {
        return {
            get: function () {
                return $(_OMSEL.title).text();
            },
            set: function (newValue) {
                $(_OMSEL.title).text(newValue);
            }
        };
    });
});

// omHTML.date
omHTML.ready(function () {
    this.defineProperty('date', function () {
        return {
            get: function () {
                return $(_OMSEL.date).text();
            },
            set: function (newValue) {
                $(_OMSEL.date).text(newValue);
            }
        }
    });
});

// omHTML.content
omHTML.ready(function () {
    this.defineProperty('content', function () {
        return {
            get: function () {
                return $(_OMSEL.content).html();
            },
            set: function (newValue) {
                $(_OMSEL.content).html(newValue);
                $(_OMSEL.contentImage).each(function(index, element) {
                    var image = $(element);
                    var url = image.attr('src');
                    if (!url) { image.remove(); return; }
                    image.attr('src', _OMURL.newsAvatar.src);
                    image.attr('srcset', _OMURL.newsAvatar.srcset);
                    omApp.service.data.cachedResourceForURL(url, function (sourcePath) {
                        if (!sourcePath) { return; }
                        image.attr("src", sourcePath);
                        image.removeAttr('srcset');
                    });
                });
            }
        };
    });
});

// omHTML.numberOfComments
omHTML.ready(function () {
    this.defineProperty("numberOfComments", function () {
        var _numberOfComments = 0;
        function _setNumberOfComments(count) {
            _numberOfComments = parseInt(count);
            if (_numberOfComments <= 0) {
                $(_OMSEL.toolBarNumberOfComments).css("visibility", "hidden");
            } else {
                $(_OMSEL.toolBarNumberOfComments).css("visibility", "visible");
                if (_numberOfComments < 1000) {
                    $(_OMSEL.toolBarNumberOfComments).text(_numberOfComments);
                } else {
                    $(_OMSEL.toolBarNumberOfComments).text("999+");
                }
            }
        }
        return {
            get: function () {
                return _numberOfComments;
            },
            set: _setNumberOfComments
        }
    })
});

// omHTML.writer
omHTML.ready(function () {
    this.defineProperty('writer', function () {
        
        var _writer = new (function () {
            Object.defineProperties(this, {
                avatar: {
                    get: function () {
                        return $(_OMSEL.writer.avatar).css('background-image');
                    },
                    set: function (newValue) {
                        omApp.service.data.cachedResourceForURL(newValue, function (filePath) {
                            $(_OMSEL.writer.avatar).css('background-image', filePath);
                        });
                    }
                },
                name: {
                    get: function () {
                        return $(_OMSEL.writer.name).text();
                    },
                    set: function (newValue) {
                        $(_OMSEL.writer.name).text(newValue);
                    }
                }
            });
        });
        
        return {
            get: function () {
                return _writer;
            }
        }
    })
});

// omHTML.link
omHTML.ready(function () {
    this.defineProperty('link', function () {
        var _link = new (function () {
            
            Object.defineProperties(this, {
                text: {
                    get: function () {
                        return $(_OMSEL.link).text();
                    },
                    set: function (newValue) {
                        $(_OMSEL.link).text(newValue);
                    }
                },
                href: {
                    get: function () {
                        return $(_OMSEL.link).attr('href');
                    },
                    set: function (newValue) {
                        $(_OMSEL.link).attr('href', newValue);
                    }
                }
            });
        });
        return {
            get: function () {
                return _link;
            }
        }
    });
});

// omHTML.actions 
omHTML.ready(function () {
    this.defineProperties(function () {
        var _actions = new (function () {
            var _numberOfLikes = 0;
            var _numberOfDislikes = 0;
            
            function _setNumberOfLikes(count) {
                _numberOfLikes = Math.max(0, count);
                $(_OMSEL.actionsLikeText).text(_numberOfLikes);
            }
        
            function _setNumberOfDislikes(count) {
                _numberOfDislikes = Math.max(0, count);
                $(_OMSEL.actionsDislikeText).text(_numberOfDislikes);
            }
        
            // -1 踩；0 无；1 赞。
            var _userLikeDislikeState = 0;
            function _setUserLikeDislikeState(state) {
                _userLikeDislikeState = state;
                switch (_userLikeDislikeState) {
                    case -1:
                        $(_OMSEL.actionsLike).toggleClass("selected", false);
                        $(_OMSEL.actionsDislike).toggleClass("selected", true);
                        break;
                    case 1:
                        $(_OMSEL.actionsLike).toggleClass("selected", true);
                        $(_OMSEL.actionsDislike).toggleClass("selected", false);
                        break;
                    default:
                        $(_OMSEL.actionsLike).toggleClass("selected", false);
                        $(_OMSEL.actionsDislike).toggleClass("selected", false);
                        break;
                }
            }
        
            Object.defineProperties(this, {
                numberOfLikes: {
                    get: function () {
                        return _numberOfLikes;
                    },
                    set: _setNumberOfLikes
                },
                numberOfDislikes: {
                    get: function () {
                        return _numberOfDislikes;
                    },
                    set: _setNumberOfDislikes
                },
                userLikeDislikeState: {
                    get: function () {
                        return _userLikeDislikeState;
                    },
                    set: _setUserLikeDislikeState
                }
            })
        });
        return {
            actions: {
                get: function () {
                    return _actions;
                }
            }
        }
    });
});

// omHTML.share
omHTML.ready(function () {
    this.defineProperty('share', function () {
        var _share = new  (function () {
            
            function _hide(name) {
                $(_OMSEL.sharePlatforms).find("." + name).hide();
            }
            
            function _show(name) {
                $(_OMSEL.sharePlatforms).find("." + name).show();
            }
            
            Object.defineProperties(this, {
                title: {
                    get: function () {
                        return $(_OMSEL.shareTitle).text();
                    },
                    set: function (newValue) {
                        $(_OMSEL.shareTitle).text(newValue);
                    }
                },
                hide: function () {
                    return _hide;
                },
                show: function () {
                    return _show;
                }
            })
        });
        return {
            get: function () {
                return _share;
            }
        }
    });
});

// omHTML.more
omHTML.ready(function () {
    
    this.defineProperty('more', function () {
        var _more = (function () {
            var _template = $(_OMSEL.moreListItemFist).clone();
            
            var _list = new _OMList(
                window.omHTML.name,
                "More List",
                _OMSEL.moreList,
                function (index) {
                    var _selector = (window.omHTML.name + "_More_List_" + index).replace(/[^a-z_0-9]+/ig, "_");
                    var _element = _template.clone();
                    _element.attr("id", _selector);
                    $(_OMSEL.moreList).append(_element);
                    _selector = "#" + _selector;
                    
                    var model = new _OMListRow(_selector);
            
                    var _writer = new (function () {
                        Object.defineProperties(this, {
                            avatar: {
                                get: function() {
                                    return $(_selector).find(_OMSEL.moreListItem_find_WriterAvatar).attr("src");
                                },
                                set: function (newValue) {
                                    omApp.service.data.cachedResourceForURL(newValue, function (sourcePath) {
                                        $(_selector).find(_OMSEL.moreListItem_find_WriterAvatar)
                                            .attr("src", sourcePath)
                                            .removeAttr("srcset");
                                    });
                                }
                            },
                            name: {
                                get: function() {
                                    return $(_selector).find(_OMSEL.moreListItem_find_WriterName).text();
                                },
                                set: function (newValue) {
                                    $(_selector).find(_OMSEL.moreListItem_find_WriterName).text(newValue);
                                }
                            }
                        });
                    })();
                    Object.defineProperties(model, {
                        title: {
                            get: function () {
                                return $(_selector).find(_OMSEL.moreListItem_find_Title).text();
                            },
                            set: function (newValue) {
                                $(_selector).find(_OMSEL.moreListItem_find_Title).text(newValue);
                            }
                        },
                        avatar: {
                            get: function () {
                                return $(_selector).find(_OMSEL.moreListItem_find_Avatar).attr('src');
                            },
                            set: function (newValue) {
                                omApp.service.data.cachedResourceForURL(newValue, function (sourcePath) {
                                    $(_selector).find(_OMSEL.moreListItem_find_Avatar)
                                        .attr('src', sourcePath)
                                        .removeAttr('srcset');
                                });
                            }
                        },
                        writer: {
                            get: function () {
                                return _writer;
                            }
                        }
                    });
                    return model;
                },
                function (data, row) {
                    row.title           = data.title;
                    row.avatar          = data.avatar;
                    row.writer.name     = data.writer.name;
                    row.writer.avatar   = data.writer.avatar;
                },
                function (oldCount, newCount) {
                    if (newCount <= 0) {
                        $(_OMSEL.more).hide();
                    } else if ($(_OMSEL.more).is(":hidden")) {
                        $(_OMSEL.more).show();
                    }
                }
            );
            return (new _OMModule("More", _OMSEL.moreTitle, _list));
        })();
        
        return {
            get: function () {
                return _more;
            }
        }
    });
});

// omHTML.hots, omHTML.comments, omHTML.floor
omHTML.ready(function () {
    
    this.defineProperties(function () {
        
        
        // Hot Comments.
        var _hots = _createCommentsModule(
            "Hots",
            _OMSEL.hotsTitle,
            "Hot Comments List",
            _OMSEL.hotsList,
            true,
            function (oldCount, newCount) {
                if (newCount === 0) {
                    $(_OMSEL.hotsList).text("لايك لوجه الله يا محسنين");
                }
                return true;
            }
        );
        _hots.list.element.empty();
        
        // Normal Comments.
        var _comments = _createCommentsModule(
            "Comments",
            _OMSEL.commentsTitle,
            "Comments List",
            _OMSEL.commentsList,
            true,
            function (oldCount, newCount) {
                if (newCount === 0) {
                    window.omHTML.loading.state = _OMListLoadingState.empty;
                } else {
                    if (oldCount === newCount) {
                        window.omHTML.loading.state = _OMListLoadingState.noMoreData;
                    } else {
                        window.omHTML.loading.state = _OMListLoadingState.idle;
                    }
                }
            }
        );
        _comments.list.element.empty();
    
        // Comments Floor.
        var _floor = _createCommentsModule(
            "Floor",
            _OMSEL.floorTitle,
            "Floor Comments List",
            _OMSEL.floorList,
            false,
            function (oldCount, newCount) {
                if (newCount === 0) {
                    window.omHTML.floor.loading.state = _OMListLoadingState.empty;
                } else {
                    if (oldCount === newCount) {
                        window.omHTML.floor.loading.state = _OMListLoadingState.noMoreData;
                    } else {
                        window.omHTML.floor.loading.state = _OMListLoadingState.idle;
                    }
                }
            }
        );
        _floor.list.element.empty();
    
        function _showFloor() {
            $(_OMSEL.floor).css({
                "display": "block",
                "padding-top": $(document).height() + "px",
                "-webkit-animation": "backgroundShow 0.3s",
                "-webkit-animation-fill-mode": "both"
            }).animate({
                "padding-top": "70px"
            }, '300', function () {
                
            });
            $(_OMSEL.toolBar).animate({
                paddingLeft: "16px"
            });
        }
        
        function _hideFloor() {
            $(_OMSEL.floor).css({
                // "padding-top": "70px",
                "-webkit-animation": "backgroundHide 0.3s",
                "-webkit-animation-fill-mode": "both"
            }).animate({
                "padding-top": $(document).height() + "px"
            }, '300', function () {
                $(this).css("display", "none");
            });
            $(_OMSEL.toolBar).animate({
                paddingLeft: "170px"
            });
        }
        
        var _floorLoading = new  _OMListLoading(_OMSEL.floorLoadingIcon, _OMSEL.floorLoadingText, _OMSEL.floorLoadingEmpty);
        _floorLoading.setMessageForState("上拉或点击以加载更多回复", _OMListLoadingState.idle);
        _floorLoading.setMessageForState("正在加载更多回复", _OMListLoadingState.loading);
        _floorLoading.setMessageForState("暂无更多回复，点击重新加载", _OMListLoadingState.noMoreData);
        
        var _floorHost = _createCommentRowModel("body>.floor .comments .title .host .item");
        
        Object.defineProperties(_floor, {
            show: { get: function () { return _showFloor; } },
            hide: { get: function () { return _hideFloor; } },
            host: { get: function () { return _floorHost; } },
            loading: { get: function () { return _floorLoading; } }
        });
        
        return {
            hots:       { get: function () { return _hots;      } },
            comments:   { get: function () { return _comments;  } },
            floor:      { get: function () { return _floor;     } }
        };
    });

});

omHTML.ready(function () {
    this.defineProperty('loading', function () {
        var _loading = new _OMListLoading(_OMSEL.loadingIcon, _OMSEL.loadingText, _OMSEL.loadingEmpty);
        _loading.setMessageForState("上拉或点击以加载更多评论", _OMListLoadingState.idle);
        _loading.setMessageForState("正在加载更多评论", _OMListLoadingState.loading);
        _loading.setMessageForState("暂无更多评论，点击重新加载", _OMListLoadingState.noMoreData);
        return { get: function () { return _loading; } }
    });
});

// omHTML.textInput
omHTML.ready(function () {
    this.defineProperties(function () {
        // 隐藏文本输入表单
        function _hideTextInput() {
            $(_OMSEL.textInputDiv).toggleClass('inputting', false);
            $(_OMSEL.textInputMask).css({
                "-webkit-animation": "backgroundHide 0.3s",
                "-webkit-animation-fill-mode": "both",
                display: "none"
            });
        }
    
        // 显示文本输入表单
        function _showTextInput() {
            $(_OMSEL.textInputDiv).toggleClass('inputting', true);
            $(_OMSEL.textInputMask).css({
                "-webkit-animation": "backgroundShow 0.3s",
                "-webkit-animation-fill-mode": "both",
                display: "block"
            });
            // iOS 需要设置 UIWebView.keyboardDisplayRequiresUserAction = false ，否则键盘无法弹出。
            $(_OMSEL.textInputTextArea)[0].focus();
            // mask 被点击时，隐藏输入框
            $(_OMSEL.textInputMask).one("touchstart", function () {
                $(_OMSEL.textInputTextArea).blur();
                _hideTextInput();
            });
        }
        
        var _textInput = new (function () {
            Object.defineProperties(this, {
                show: { get: function () { return _showTextInput; }},
                hide: { get: function () { return _hideTextInput; }},
                placeholder: {
                    get: function () {
                        return $(_OMSEL.textInputTextArea).attr("placeholder");
                    },
                    set: function (newValue) {
                        $(_OMSEL.textInputTextArea).attr("placeholder", newValue);
                    }
                }
                
            })
        });
    
        return {
            textInput: {
                get: function () {
                    return _textInput;
                }
            }
        }
    });
});


// Events
omHTML.ready(function () {
    
    var kHTMLName = this.name;
    
    var kSubmitTypeNews              = "News";                   // 评论文章
    var kSubmitTypeCommentsList      = "Comments List";          // 回复评论
    var kSubmitTypeHotCommentsList   = "Hot Comments List";      // 回复热门评论
    var kSubmitTypeFloorCommentsList = "Floor Comments List";    // 叠楼，楼主的 index 为 -1
    var _submit = {
        type: kSubmitTypeNews,
        index: -1
    }; // 输入类型。Comment/Reply
    
    var kPlaceholderComment = "شارك برأيك…";  // 给文章添加评论
    var kPlaceholderReply   = "شارك برأيك…";  // 回复评论默认
    var kPlaceholderReplyTo = function (name) {  // 对 评论 进行回复
        return  "رد " + name;
    };
    
    function _showTextInput(submitType, index, placeholder) {
        window.omHTML.textInput.placeholder = placeholder;
        _submit.type = submitType;
        _submit.index = index;
        window.omHTML.textInput.show();
    }
    
    function _hideTextInput() {
        window.omHTML.textInput.placeholder = "";
        window.omHTML.textInput.hide();
    }
    
    // 关注按钮
    $(_OMSEL.follow).click(function () {
        var _this = $(this);
        omApp.service.event.wasClicked(kHTMLName, "Follow Button", _this.hasClass("selected"), function (isSelected) {
            _this.toggleClass("selected", isSelected);
        });
    });
    
    // 查看原文
    $(_OMSEL.link).click(function () {
        omApp.service.event.wasClicked(kHTMLName, "Content Link");
    });
    
    // 点赞
    $(_OMSEL.actionsLike).click(function () {
        var _this = $(this);
        omApp.service.event.wasClicked(kHTMLName, "Action Like", _this.hasClass("selected"), function (isSelected) {
            _this.toggleClass("selected", isSelected);
            _showPlusMinusAnimationOnElement(_this, isSelected, _this.css("border-color"));
            if (isSelected) {
                // 如果已点踩，则取消点踩，并 -1
                if ( $(_OMSEL.actionsDislike).hasClass("selected") ) {
                    $(_OMSEL.actionsDislike).removeClass("selected");
                    window.omHTML.actions.numberOfDislikes -= 1;
                }
                window.omHTML.actions.numberOfLikes += 1;
            } else {
                window.omHTML.actions.numberOfLikes -= 1;
            }
        });
    });
    
    // 点踩
    $(_OMSEL.actionsDislike).click(function () {
        var _this = $(this);
        omApp.service.event.wasClicked(window.omHTML.name, "Action Dislike", _this.hasClass("selected"), function (isSelected) {
            _this.toggleClass("selected", isSelected);
            _showPlusMinusAnimationOnElement(_this, isSelected, _this.css("border-color"));
            if (isSelected) {
                if ( $(_OMSEL.actionsLike).hasClass("selected") ) {
                    $(_OMSEL.actionsLike).removeClass("selected");
                    window.omHTML.actions.numberOfLikes -= 1;
                }
                window.omHTML.actions.numberOfDislikes += 1;
            } else {
                window.omHTML.actions.numberOfDislikes -= 1;
            }
        });
    });
    
    // 举报
    $(_OMSEL.actionsReport).click(function () {
        omApp.service.event.wasClicked(window.omHTML.name, "Action Report");
    });
    
    // 分享
    $(_OMSEL.sharePlatformItem).click(function () {
        omApp.service.event.wasClicked(window.omHTML.name, "Share Button", $(this).attr("class"));
    });
    
    // 相关新闻被点击
    $(_OMSEL.more).on("click", ".list .item", function () {
        omApp.service.event.didSelectRowAtIndex(kHTMLName, window.omHTML.more.list.name, $(this).index());
        return false;
    });
    
    // 热评内容被点击，打开叠楼
    $(_OMSEL.hots).on("click", ".list .item>.content", function () {
        window.omHTML.floor.show();
        var row = $(this).parents(".item");
        var index = row.index();
        var newItem = row.clone(true);
        $(_OMSEL.floorHost).html(newItem);
        $(_OMSEL.floorHost).find(".showAll").click();
        
        $(_OMSEL.floorComments).scrollTop(0);
        window.omHTML.floor.list.identifier = "hots_" + index;
        window.omHTML.floor.loading.state = _OMListLoadingState.loading;
        
        omApp.service.event.didSelectRowAtIndex(kHTMLName, window.omHTML.hots.list.name, index, function () {
            window.omHTML.floor.list.reloadData();
        });
        return false;
    });
    
    // 热评回复按钮被点击，直接回复
    $(_OMSEL.hots).on("click", ".list>.item>.toolBar>.reply", function () {
        var row = $(this).parents(".item");
        var index = row.index();
        _showTextInput(kSubmitTypeHotCommentsList, index, kPlaceholderReplyTo(row.find(_OMSEL.commentsListItem_find_WriterName).text()));
        return false;
    });

    // 普通评论内容点击
    $(_OMSEL.comments).on("click", ".list .item>.content", function () {
        window.omHTML.floor.show();
        var row = $(this).parents(".item");
        var index = row.index();
        
        var newItem = row.clone(true);
        $(_OMSEL.floorHost).html(newItem);
        $(_OMSEL.floorHost).find(".showAll").click();
        
        $(_OMSEL.floorComments).scrollTop(0);
        window.omHTML.floor.list.identifier = "comments_" + index;
        window.omHTML.floor.loading.state = _OMListLoadingState.loading;
        
        omApp.service.event.didSelectRowAtIndex(kHTMLName, window.omHTML.comments.list.name, index, function () {
            window.omHTML.floor.list.reloadData();
        });
        return false;
    });
    
    // 普通评论回复按钮被点击
    $(_OMSEL.comments).on("click", ".list>.item>.toolBar>.reply", function () {
        var row = $(this).parents(".item");
        var index = row.index();
        _showTextInput(kSubmitTypeCommentsList, index, kPlaceholderReplyTo(row.find(_OMSEL.commentsListItem_find_WriterName).text()));
        return false;
    });
    
    // 叠楼楼主点击，回复楼主
    $(_OMSEL.floor).on("click", ".title .item>.content, .title .item>.toolBar>.reply", function () {
        var item = $(this).parents(".item");
        _showTextInput(kSubmitTypeFloorCommentsList, -1, kPlaceholderReplyTo(item.find(_OMSEL.commentsListItem_find_WriterName).text()));
        return false;
    });
    
    // 叠楼列表点击
    $(_OMSEL.floor).on("click", ".comments .list .item>.content, .comments .list .item>.toolBar>.reply", function () {
        var row = $(this).parents(".item");
        var index = row.index();
        _showTextInput(kSubmitTypeFloorCommentsList, index, kPlaceholderReplyTo(row.find(_OMSEL.commentsListItem_find_WriterName).text()));
        return false;
    });
    
    
    function _commentLikeAction(likeButton, eventName) {
        var row = likeButton.parents(".item");
        omApp.service.event.wasClicked(kHTMLName, eventName, row.index());
        var isSelected = !likeButton.hasClass("selected");
        likeButton.toggleClass("selected", isSelected);
        _showPlusMinusAnimationOnElement(likeButton, isSelected, likeButton.css("color"));
    
        var number = likeButton.find(".text");
        number.text(parseInt(number.text()) + (isSelected ? +1 : -1));
        return false;
    }
    
    // 热门评论点赞
    $("div.comments.hots").on("click", ".list .item>.infoBar .like", function () {
        _commentLikeAction($(this), "Hots Comments List Like Action");
    });
    
    // 热门评论点赞
    $("div.comments.normal").on("click", ".list .item>.infoBar .like", function () {
        _commentLikeAction($(this), "Comments List Like Action");
    });
    
    //  叠楼列表评论点赞
    $("div.floor div.comments").on("click", ".list .item>.infoBar .like", function () {
        _commentLikeAction($(this), "Floor List Like Action");
    });
    
    // 叠楼楼主点赞
    $("div.floor div.comments .title").on("click", ".host .item>.infoBar .like", function () {
        _commentLikeAction($(this), "Floor Host Like Action");
    });
    
    // 评论列表的空视图点击
    $(_OMSEL.loadingEmpty).on("click", function () {
        _showTextInput(kSubmitTypeNews, -1, "评论文章");
        return false;
    });
    
    // 叠楼空视图点击
    $(_OMSEL.floorLoadingEmpty).on("click", function () {
        _showTextInput(kSubmitTypeFloorCommentsList, -1, kPlaceholderReplyTo(omHTML.floor.host.writer.name));
        return false;
    });
    
    // 叠楼关闭按钮
    $(_OMSEL.floorClose).click(function () {
        window.omHTML.floor.hide();
        return false;
    });
    
    // 评论按钮点击，输入框
    $(_OMSEL.toolBarInput + ", " + _OMSEL.toolBarComment).click(function () {
        var type = kSubmitTypeNews, placeholder = kPlaceholderComment;
        if (!$(_OMSEL.floor).is(":hidden")) {
            type = kSubmitTypeFloorCommentsList;
            placeholder = kPlaceholderReply;
        }
        _showTextInput(type, -1, placeholder);
    });
    
    // 收藏按钮点击
    $(_OMSEL.toolBarCollect).on("click", function () {
        omApp.service.event.wasClicked(kHTMLName, "Tool Bar Collect");
        $(this).toggleClass("selected");
        return false;
    });
    
    // 分享按钮点击
    $(_OMSEL.toolBarShare).on("click", function () {
        omApp.service.event.wasClicked(kHTMLName, "Tool Bar Share");
        return false
    });
    
    // 输入框。
    $("body>.toolBar .textInput textarea").focus(function () {
        var type = kSubmitTypeNews, placeholder = kPlaceholderComment;
        if (!$(_OMSEL.floor).is(":hidden")) {
            type = kSubmitTypeFloorCommentsList;
            placeholder = kPlaceholderReply;
        }
        _showTextInput(type, -1, placeholder);
        setTimeout(function () {
            $("body>.toolBar .textInput")[0].scrollIntoView(true);
        }, 300);
        return false;
    }).blur(function () {
        _hideTextInput();
        return false;
    }).keyup(function () {
        $("body>.toolBar .textInput")[0].scrollIntoView(true);
        return false;
    });
    
    $(_OMSEL.textInputTextArea).on("change, input", function () {
        var count = $(this).val().length;
        $(_OMSEL.textInputSubmit).attr("disabled", count === 0);
        $(_OMSEL.textInputNumberOfWords).text(count);
    });
    
    $(_OMSEL.textInputSubmit).click(function (event) {
        event.preventDefault();
        var comment = $(_OMSEL.textInputTextArea).val();
        $(_OMSEL.textInputTextArea).val("");
        $(_OMSEL.textInputSubmit).attr("disabled", true);
        $(_OMSEL.textInputNumberOfWords).text(0);
        window.omHTML.textInput.hide();
        omApp.service.event.wasClicked(kHTMLName, "Comment Submit", {"content": comment, "submit": _submit});
        return false;
    });
    
    //
    $(_OMSEL.navBack).on("click", function () {
        omApp.navigation.pop(true);
    });
    
    $(_OMSEL.navClose).on("click", function () {
        omApp.navigation.popTo(0, true);
    });
    
    $(_OMSEL.navInfo).on("click", function () {
        omApp.service.event.wasClicked(kHTMLName, "Navigation Bar Info");
    });
    
    function _commentsLoadMoreIfNeeded() {
        switch (window.omHTML.loading.state) {
            case _OMListLoadingState.idle:
            case _OMListLoadingState.noMoreData:
                window.omHTML.loading.state = _OMListLoadingState.loading;
                omApp.service.event.wasClicked(kHTMLName, "Comments Load More", null, function () {
                    window.omHTML.comments.list.reloadData();
                });
                break;
            default:
                break;
        }
    }
    
    var _isCommentsLoadingShowing = false;
    
    $("div.main").on("scroll", function () {
        var contentHeight = this.scrollHeight; // 总高度
        var contentOffsetY = this.scrollTop;
        var height = this.offsetHeight;
        var d = contentHeight - contentOffsetY - height;
        if (d < 25) {
            if (!_isCommentsLoadingShowing) {
                _isCommentsLoadingShowing = true;
                _commentsLoadMoreIfNeeded();
            }
        } else if (_isCommentsLoadingShowing && d > 50) {
            _isCommentsLoadingShowing = false;
        }
    });
    
    $(_OMSEL.loadingText).on("click", function () {
        _commentsLoadMoreIfNeeded();
    });
    
    function _floorLoadMoreIfNeeded() {
        switch (window.omHTML.floor.loading.state) {
            case _OMListLoadingState.idle:
            case _OMListLoadingState.noMoreData:
                window.omHTML.floor.loading.state = _OMListLoadingState.loading;
                omApp.service.event.wasClicked(kHTMLName, "Floor Load More", null, function () {
                    window.omHTML.floor.list.reloadData();
                });
                break;
            default:
                break;
        }
    }
    
    var _isFloorLoadingShowing = false;
    
    $("div.floor .comments").on("scroll", function () {
        var contentHeight   = this.scrollHeight; // 总高度
        var contentOffsetY  = this.scrollTop;
        var height          = this.offsetHeight;
        var d = contentHeight - contentOffsetY - height;
        if (d < 25) {
            if (!_isFloorLoadingShowing) {
                _isFloorLoadingShowing = true;
                _floorLoadMoreIfNeeded();
            }
        } else if (_isFloorLoadingShowing && d > 50)  {
            _isFloorLoadingShowing = false;
        }
    });
    
    $(_OMSEL.floorLoadingText).on("click", function () {
        _floorLoadMoreIfNeeded();
    });
    
    var _userTouch = {
        start: {x: 0, y: 0, timeStamp: 0},
        current: {x: 0, y: 0, timeStamp: 0},
        velocity: 0,
        isDragging: false
    };
    document.body.addEventListener('touchstart', function (event) {
        if (_userTouch.isDragging) { return; }
        if ($(_OMSEL.floor).is(":hidden")) { return; }
        
        var touch = event.targetTouches[0];
        if (touch.pageY > 70) { return; }
        
        _userTouch.start.x = touch.pageX;
        _userTouch.start.y = touch.pageY;
        _userTouch.start.timeStamp = event.timeStamp;
        
        _userTouch.isDragging = true;
        _userTouch.current.x = _userTouch.start.x;
        _userTouch.current.y = _userTouch.start.y;
        _userTouch.current.timeStamp = _userTouch.start.timeStamp;
        
        _userTouch.velocity = 0;
        
        event.preventDefault();
    });
    
    document.body.addEventListener('touchmove', function (event) {
        if (!_userTouch.isDragging) { return; }
        
        var touch = event.targetTouches[0];
        var velocity = (touch.pageY - _userTouch.current.y) * 1000 / (event.timeStamp - _userTouch.current.timeStamp);
        
        _userTouch.current.x = touch.pageX;
        _userTouch.current.y = touch.pageY;
        _userTouch.current.timeStamp = event.timeStamp;
        _userTouch.velocity = velocity;
        
        var d = 70 + touch.pageY - _userTouch.start.y;
        $(_OMSEL.floor).css("padding-top", Math.max(d, 70) + "px");
        
        event.preventDefault();
    });
    
    function _floorDragEnded(event) {
        if (!_userTouch.isDragging) { return; }
        _userTouch.isDragging = false;
        
        if (_userTouch.velocity < 800) {
            var touch = event.changedTouches[0];
            var d = 70 + touch.pageY - _userTouch.start.y;
            if (d < 200) {
                $(_OMSEL.floor).animate({
                    paddingTop: "70px"
                });
                return false;
            }
        }
        
        var floorDiv = $(_OMSEL.floor);
        var top = parseFloat(floorDiv.css("padding-top").replace("px", ""));
        var height = $(document).height();
        var speed = _userTouch.velocity / 200;
        var intervalID = setInterval(function () {
            speed += 0.5;
            top += speed;
            floorDiv.css("padding-top", top + "px" );
            if (top > height) {
                clearInterval(intervalID);
                $(_OMSEL.floorClose).click();
            }
        }, 5);
    }
    
    document.body.addEventListener('touchcancel', _floorDragEnded);
    document.body.addEventListener('touchend', _floorDragEnded);
    
    // 阻止弹簧效果
    // var _touchY = 0;
    // $("body>div.nav, body>div.toolBar, body>div.floor .header").bind("touchmove", function (event) {
    //     event.preventDefault();
    //     return false;
    // });
    //
    // $("div.main, .floor .comments").on("touchstart", function (event) {
    //     _touchY = event.originalEvent.targetTouches[0].pageY;
    // }).on("touchmove", function (event) {
    //     var offsetY = this.scrollTop;
    //     if (offsetY <= 0) {
    //         if (event.originalEvent.targetTouches[0].pageY > _touchY) {
    //             event.preventDefault();
    //         }
    //     } else if ( (offsetY + this.offsetHeight >= this.scrollHeight) ) {
    //         if (event.originalEvent.targetTouches[0].pageY < _touchY) {
    //             event.preventDefault();
    //         }
    //     }
    // });
});




$(function () {
    omHTML.documentIsReady();
});





// +1 -1 动画
function _showPlusMinusAnimationOnElement(JQueryElement, isPlus, color) {
    var elementWidth  = JQueryElement.width();
    var elementHeight = JQueryElement.height();
    
    var elementLeft = parseInt(JQueryElement.offset().left);
    var elementTop  = parseInt(JQueryElement.offset().top);
    
    var animationDiv = document.createElement("div");
    animationDiv.style.position     = "absolute";
    animationDiv.style.fontFamily   = "OM-Arabic-Number-Title-Regular";
    animationDiv.style.fontSize     = "12px";
    animationDiv.style.color        = color;
    animationDiv.style.width        = "36px";
    animationDiv.style.height       = "12px";
    animationDiv.style.zIndex       = 98;
    animationDiv.style.textAlign    = "center";
    
    var fromValue = 18, toValue = 36;
    if (isPlus) {
        animationDiv.innerHTML          = "+ 1";
    } else {
        animationDiv.innerHTML          = "- 1";
        fromValue = 36; toValue = 18;
    }
    
    $(document.body).append($(animationDiv));
    $(animationDiv).css({
        'left': (elementLeft + elementWidth / 2.0 - 18) + 'px',
        'top': (elementTop + elementHeight / 2.0 - fromValue) + 'px'
    }).animate({
        left: elementLeft + elementWidth / 2.0 - 18,
        top: elementTop + elementHeight / 2.0 - toValue
    }, '400', function() {
        $(this).fadeIn('fast').fadeOut('slow', function() {
            $(this).remove();
        });
    });
}

// Model
function _OMModule(_name, _titleElementSelector, _listModel) {
    Object.defineProperties(this, {
        name: { get: function () { return _name; } },
        title: {
            get: function () { return $(_titleElementSelector).text(); },
            set: function (newValue) { $(_titleElementSelector).text(newValue); }
        },
        list: { get: function () { return _listModel; } }
    });
}

// List Row Class
function _OMListRow(_elementSelector) {
    Object.defineProperty(this, 'element', {
        get: function () {
            return $(_elementSelector);
        }
    });
}

// List Class.
function _OMList(
    _htmlName,                      // HTML Name
    _listName,                      // List Name
    _listElementSelector,           // list
    _createRowWithIndex,            // 创建 row模型 的函数，返回模型时，其元素已添加到视图上。
    _didLoadDataForRowAtIndex,       // 使用数据填充 row
    _didFinishReloadData
) {
    var _allRows     = [];
    
    function _loadDataForRowAtIndex(row, index) {
        omApp.service.data.dataForRowAtIndex(_htmlName, _listName, index, function (data) {
            _didLoadDataForRowAtIndex(data, row, index);
        });
    }
    
    // 刷新列表。查询行数 > 判断行数根据 needsReloadAll 决定是遍历所有行，还是只遍历发生变化的行（数量）；
    function _reloadData(needsReloadAll) {
        if (_allRows.length === 0) {
            $(_listElementSelector).empty();
        }
        
        omApp.service.data.numberOfRows(_htmlName, _listName, function (count) {
            var oldCount = _allRows.length;
            var index = 0;
            if (oldCount <= count) {
                if (needsReloadAll) {
                    for (index = 0; index < count; index += 1) {
                        var row = null;
                        if (index < _allRows.length) {
                            row = _allRows[index];
                        } else {
                            // 只有没有时才创建
                            var newRow1 = _createRowWithIndex(index);
                            _allRows.push(newRow1);
                            row = newRow1;
                        }
                        _loadDataForRowAtIndex(row, index);
                    }
                } else {
                    // 只刷新新增的。
                    for (index = oldCount; index < count; index += 1) {
                        var newRow2 = _createRowWithIndex(index);
                        _allRows.push(newRow2);
                        _loadDataForRowAtIndex(newRow2, index);
                    }
                }
            } else {
                // 移除模型
                var rows = _allRows.splice(count, oldCount - count);
                // 移除视图
                for (index = 0; index < rows.length; index += 1) {
                    rows[index].element.remove();
                }
                if (needsReloadAll) {
                    for (index = 0; index < _allRows.length; index += 1) {
                        _loadDataForRowAtIndex(_allRows[index], index);
                    }
                }
            }
            
            _didFinishReloadData(oldCount, count);
        });
    }
    
    function _reset() {
        _allRows.splice(0, _allRows.length);
        $(_listElementSelector).empty();
    }
    
    var _identifier = 0;
    
    Object.defineProperties(this, {
        name: { get: function () { return _listName; } },
        element: { get: function () { return $(_listElementSelector); } },
        reloadData: { get: function () { return _reloadData; } },
        reset: { get: function () { return _reset; } },
        identifier: {
            get: function () { return _identifier; },
            set: function (newValue) {
                if (newValue !== _identifier) {
                    _identifier = newValue;
                    _reset();
                }
            }
        }
    });
}

function _createCommentRowModel(_selector) {
    var _writer = new (function () {
        Object.defineProperties(this, {
            name: {
                get: function () {
                    return $(_selector).find(_OMSEL.commentsListItem_find_WriterName).text();
                },
                set: function (newValue) {
                    $(_selector).find(_OMSEL.commentsListItem_find_WriterName).text(newValue);
                }
            },
            avatar: {
                get: function () {
                    return $(_selector).find(_OMSEL.commentsListItem_find_WriterAvatar).text();
                },
                set: function (newValue) {
                    omApp.service.data.cachedResourceForURL(newValue, function (filePath) {
                        $(_selector).find(_OMSEL.commentsListItem_find_WriterAvatar)
                            .attr('src', filePath)
                            .removeAttr('srcset');
                    });
                }
            }
        });
    });
    
    var _replyTo = new (function () {
        var _user = {};
        Object.defineProperty(_user, "name", {
            get: function () {
                return $(_selector).find(_OMSEL.commentsListItem_find_ReplyToUserName).text();
            },
            set: function (newValue) {
                $(_selector).find(_OMSEL.commentsListItem_find_ReplyToUserName).text(newValue);
            }
        });
        Object.defineProperties(this, {
            user: { get: function () { return _user; } },
            content: {
                get: function () {
                    return $(_selector).find(_OMSEL.commentsListItem_find_ReplyToContent).text();
                },
                set: function (newValue) {
                    $(_selector).find(_OMSEL.commentsListItem_find_ReplyToContent).text(newValue);
                }
            }
        })
    })();
    
    var _content = null;
    
    function _setContent(content, isCompress) {
        _content = content;
        if (isCompress && (_content+"").length > 205) {
            var contentDiv = $(_selector).find(_OMSEL.commentsListItem_find_Content);
            contentDiv.text(_content.substring(0, 205) + "... ");
            var ele = $("<a href=\"javascript:void(0);\" class=\"showAll\">أقرأ المزيد</a>");
            ele.attr('alt', _content);
            ele.one("click", function () {
                $($(this).parent()).text($(this).attr('alt'));
                return false;
            });
            contentDiv.append(ele);
        } else {
            $(_selector).find(_OMSEL.commentsListItem_find_Content).text(_content);
        }
    }
    
    var _model = new _OMListRow(_selector);
    
    Object.defineProperties(_model, {
        writer: { get: function () { return _writer; } },
        isLiked: {
            get: function () {
                return $(_selector).find(_OMSEL.commentsListItem_find_Like).hasClass("selected");
            },
            set: function (newValue) {
                $(_selector).find(_OMSEL.commentsListItem_find_Like).toggleClass("selected", newValue);
            }
        },
        numberOfLikes: {
            get: function () {
                return $(_selector).find(_OMSEL.commentsListItem_find_LikeText).text();
            },
            set: function (newValue) {
                $(_selector).find(_OMSEL.commentsListItem_find_LikeText).text(newValue);
            }
        },
        content: {
            get: function () {
                return _content;
            },
            set: function (newValue) {
                _setContent(newValue, false);
            }
        },
        setContent: {
            get: function () {
                return _setContent;
            }
        }
        ,
        date: {
            get: function () {
                return $(_selector).find(_OMSEL.commentsListItem_find_Date).text();
            },
            set: function (newValue) {
                $(_selector).find(_OMSEL.commentsListItem_find_Date).text(newValue);
            }
        },
        numberOfReplies: {
            get: function () {
                return $(_selector).find(_OMSEL.commentsListItem_find_ReplyNumber).text();
            },
            set: function (newValue) {
                $(_selector).find(_OMSEL.commentsListItem_find_ReplyNumber).text(newValue);
            }
        },
        replyTo: {
            get: function () {
                return _replyTo;
            }
        }
    });
    return _model;
}

// 因为热评和评论的相似性，可以用同一个函数创建。
function _createCommentsModule(
    _moduleName,
    _moduleTitleSelector,       // 标题文本
    _listName,                  // 列表名称，标识列表
    _listSelector,              // 列表
    _compressContent,           // 是否需要压缩内容
    _didFinishReloadData        // 是否创建列表行元素
    ) {
    
    var _htmlName = omHTML.name;
    var _template = $(_listSelector).children(":first").clone();
    
    function _createRowWithIndex(index) {
        var _element = _template.clone();
        var _selectorName = (_htmlName + "_" + _listName + "_" + index).replace(/[^a-z_0-9]+/ig, "_");
        _element.attr("id", _selectorName);
        $(_listSelector).append(_element);
        return _createCommentRowModel("#" + _selectorName)
    }
    
    
    var _list = new _OMList(
        _htmlName,
        _listName,
        _listSelector,
        _createRowWithIndex,
        function (data, row) {
            row.writer.name     = data.writer.name;
            row.writer.avatar   = data.writer.avatar;
            row.setContent(data.content, _compressContent);
            row.isLiked         = data.isLiked;
            row.numberOfLikes   = data.numberOfLikes;
            row.date            = data.date;
            row.numberOfReplies = data.numberOfReplies;
            
            if (!!data.replyTo) {
                row.replyTo.user.name = data.replyTo.user.name;
                row.replyTo.content = data.replyTo.content;
                row.element.find(_OMSEL.commentsListItem_find_ReplyTo).show();
            } else {
                row.element.find(_OMSEL.commentsListItem_find_ReplyTo).hide();
            }
        },
        _didFinishReloadData
    );
    
    return (new _OMModule(_moduleName, _moduleTitleSelector, _list));
}


function _OMListLoading(_iconSelector, _textSelector, _emptySelector) {
    
    var _state = _OMListLoadingState.idle;
    var _messages = {};
    
    function _setState(state) {
        switch (state) {
            case _OMListLoadingState.empty:
                $(_emptySelector).show();
                $(_iconSelector).hide();
                $(_textSelector).hide();
                break;
                
            case _OMListLoadingState.loading:
                $(_emptySelector).hide();
                $(_iconSelector).show();
                $(_textSelector).show().text(_messages[state]);
                break;
                
            case _OMListLoadingState.idle:
            case _OMListLoadingState.noMoreData:
                $(_emptySelector).hide();
                $(_iconSelector).hide();
                $(_textSelector).show().text(_messages[state]);
                break;
                
            default:
                return;
        }
        _state = state;
    }
    
    function _setMessageForState(message, state) {
        _messages[state] = message;
    }
    
    Object.defineProperties(this, {
        state: {
            get: function () {
                return _state;
            },
            set: _setState
        },
        setMessageForState: {
            get: function () {
                return _setMessageForState;
            }
        }
    });
}














