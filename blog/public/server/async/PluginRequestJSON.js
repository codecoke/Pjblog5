﻿module.exports = new Class(function(querys, getforms){
	var t = querys.t;
	if ( !t || t.length === 0 ){
		return { success: false, message: '参数不正确' };
	};
	
	t = Number(t);
	if ( t < 1 ){
		return { success: false, message: '插件ID不存在' };
	};
	
	var m = querys.m;
	if ( !m || m.length === 0 ){
		return { success: false, message: '错误的方法名' };
	};
	
	var plugins = require(':private/caches/plugins.json');
	if ( plugins.indexs && plugins.indexs[t] ){
		var folder = plugins.indexs[t].plu_folder,
			id = t,
			mark = plugins.indexs[t].plu_mark;
			
		var msg = { success: false, message: '操作失败' };
			
		fs(resolve(':private/plugins/' + folder + '/service')).exist().then(function(){
			var services = require(':private/plugins/' + folder + '/service');
			services.add('CheckUser', function(mark, callback){
				if ( !callback ){
					if ( typeof mark === 'function' ){
						callback === mark;
						mark = null;
					}else{
						callback = null;	
					}					
				};
				var aHead = false;
				if ( mark ){
					aHead = blog.user.limits.indexOf(mark) > -1;
				}else{
					aHead = blog.user.status >= 1;
				};
				if ( aHead ){
					if ( typeof callback === 'function' ){
						var cb = callback.call(this);
						if ( cb ){
							return cb;
						}else{
							return true;
						}
					}else{
						return true;
					}
				}else{
					if ( typeof callback === 'function' ){
						return { success: false, message: '非法操作' };
					}else{
						return false;
					}
				}
			});
			var service = new services(id, mark, folder);
			if ( typeof service[m] === 'function' ){
				var _msg = service[m](querys, getforms, msg);
				if ( _msg ){
					msg = _msg;
				}
			}else{
				msg = { success: false, message: '不存在的处理方法' };
			}
		}).fail(function(){
			msg.message = '找不到处理模块';
		});
		
		return msg;
	}else{
		return { success: false, message: '找不到插件' };
	}
});