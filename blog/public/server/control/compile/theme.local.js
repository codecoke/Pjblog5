﻿var theme = new Class(function(querys, getforms){
	this.data = {};
	
	var globalCache = require(':private/caches/global.json');
	var folder = globalCache.blog_theme;
	this.data.themes = [];
	this.data.theme = {};
	
	this.getUserThemes(folder);
	this.getAllThemes();
	
	return this.data;
});

theme.add('getUserThemes', function(folder){
	var that = this;
	fs(contrast(':private/themes/' + folder + '/config.json')).exist().then(function(){
		that.data.theme = require(':private/themes/' + folder + '/config.json');
		that.data.theme.shortpreview = 'private/themes/' + folder + '/' + that.data.theme.shortpreview;
		that.data.theme.bigpreview = 'private/themes/' + folder + '/' + that.data.theme.bigpreview;
		fs(contrast(':private/themes/' + folder + '/setting.json')).exist().then(function(){
			that.data.theme.setting = 'private/themes/' + folder + '/setting.json';
			that.data.theme.folder = folder;
		});
	});
});

theme.add('getAllThemes', function(){
	var that = this;
	fs(contrast(':private/themes'), true).exist().dirs().value().forEach(function(o){
		fs(contrast(':private/themes/' + o + '/config.json')).exist().then(function(){
			var config = require(':private/themes/' + o + '/config.json');
			if ( that.data.theme.mark !== config.mark ){
				config.shortpreview = 'private/themes/' + o + '/' + config.shortpreview;
				config.bigpreview = 'private/themes/' + o + '/' + config.bigpreview;
				config.folder = o;
				that.data.themes.push(config);
			}
		});
	});
});

module.exports = theme;