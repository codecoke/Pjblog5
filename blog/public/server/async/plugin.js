﻿var plugin = new Class(function(querys, getforms){
	querys.m = querys.m || '';

	if ( querys.m.length > 0 && this[querys.m] ){
		var Promise = require(':public/library/plugin');
		var BuildPromise = new Promise();
		return this[querys.m](querys, getforms, BuildPromise);
	}else{
		return { success: false, message: '找不到模块' };
	}
});

plugin.add('install', function(querys, getforms, Promise){
	var id = getforms().id;
	return Promise.install(id);
});

plugin.add('uninstall', function(querys, getforms, Promise){
	var id = getforms().id;
	return Promise.uninstall(Number(id));
});

plugin.add('change', function(querys, getforms, Promise){
	var id = getforms().id;
	if ( Promise.changeStatus(Number(id)) ){
		return { success: true, message: '修改状态成功' };
	}else{
		return { success: false, message: '修改状态失败' };
	}
});

module.exports = plugin;