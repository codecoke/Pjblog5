﻿<script language="jscript" runat="server">
/*
** File: Mo.Model.Helper.asp
** Usage: define helper methods and classes for datebase operate.
** About: 
**		support@mae.im
*/
var exports=["ModelHelper","ModelCMDManager"];
var ModelHelper={
	Enums:{
		ParameterDirection:{
			INPUT:1,INPUTOUTPUT:3,OUTPUT:2,RETURNVALUE:4
		},
		DataType:{
			ARRAY:0x2000,DBTYPE_I8:20,DBTYPE_BYTES:128,DBTYPE_BOOL:11,DBTYPE_BSTR:8,DBTYPE_HCHAPTER:136,DBTYPE_STR:129,DBTYPE_CY:6,DBTYPE_DATE:7,DBTYPE_DBDATE:133,
			DBTYPE_DBTIME:134,DBTYPE_DBTIMESTAMP:135,DBTYPE_DECIMAL:14,DBTYPE_R8:5,DBTYPE_EMPTY:0,DBTYPE_ERROR:10,DBTYPE_FILETIME:64,DBTYPE_GUID:72,DBTYPE_IDISPATCH:9,
			DBTYPE_I4:3,DBTYPE_IUNKNOWN:13,LONGVARBINARY:205,LONGVARCHAR:201,LONGVARWCHAR:203,DBTYPE_NUMERIC:131,DBTYPE_PROP_VARIANT:138,DBTYPE_R4:4,DBTYPE_I2:2,DBTYPE_I1:16,
			DBTYPE_UI8:21,DBTYPE_UI4:19,DBTYPE_UI2:18,DBTYPE_UI1:17,DBTYPE_UDT:132,VARBINARY:204,VARCHAR:200,DBTYPE_VARIANT:12,VARNUMERIC:139,VARWCHAR:202,DBTYPE_WSTR:130
		},
		CommandType:{
			UNSPECIFIED:-1,TEXT:1,TABLE:2,STOREDPROC:4,UNKNOWN:8,FILE:256,TABLEDIRECT:512
		}
	},
	GetConnectionString:function(){
		var connectionstring = "";
		if(this["DB_Type"]=="OTHER" || (this.hasOwnProperty("DB_Connectionstring") && this["DB_Connectionstring"]!="")){
			connectionstring = F.format(this["DB_Connectionstring"],this["DB_Server"],this["DB_Username"],this["DB_Password"],this["DB_Name"],F.mappath(this["DB_Path"]));
		}else if(this["DB_Type"]=="ACCESS"){
			connectionstring = "provider=microsoft.jet.oledb.4.0; data source=" + F.mappath(this["DB_Path"]);
		}else if(this["DB_Type"]=="MSSQL"){
			connectionstring = F.format("provider=sqloledb.1;Persist Security Info=false;data source={0};User ID={1};pwd={2};Initial Catalog={3}",this["DB_Server"],this["DB_Username"],this["DB_Password"],this["DB_Name"]);
		}else if(this["DB_Type"]=="SQLITE"){
			connectionstring = "DRIVER={SQLite3 ODBC Driver};Database=" + F.mappath(this["DB_Path"]);
		}else if(this["DB_Type"]=="MYSQL"){
			connectionstring = F.format("DRIVER={mysql odbc " + (this["DB_Version"]||"3.51") + " driver};SERVER={0};USER={1};PASSWORD={2}",this["DB_Server"],this["DB_Username"],this["DB_Password"],this["DB_Name"]);
		}
		return connectionstring;
	},
	GetSqls:function(){
		var where_="",order_="",where2_="",groupby="",join="",on="",cname="";
		if(this.strwhere!=""){
			where_=" where " + this.strwhere + "";
			if(this.strpage>1 && this.strlimit!=-1)where2_=" and (" + this.strwhere + ")";
		}
		if(this.strgroupby!="") groupby=" group by " + this.strgroupby;
		if(this.strjoin!="")join=" " + this.strjoin + " ";
		if(this.strcname!="")cname = " " + this.strcname+" ";
		if (this.strorderby!="") order_=" order by " + this.strorderby;
		if(this.pagekeyorder=="" || this.strlimit==-1){
			this.sql="select " + this.fields + " from " + this.joinlevel + this.table + cname + join + where_ + groupby+ order_;
			if(this.base.cfg["DB_Type"]=="MYSQL")this.countsql = "select count(" + (this.strcname==""?this.table:this.strcname) + "." + this.pk + ") from " + this.joinlevel + this.table + cname + join + where_ + groupby;
		}else{
			this.countsql = "select count(" + (this.strcname==""?this.table:this.strcname) + "." + this.pk + ") from " + this.joinlevel + this.table + cname + join + where_ + groupby;
			this.sql = ModelHelper.GetSqlByTypes.apply(this,[cname,join,on,where_,groupby,order_]);
		}
	},
	GetSqlByTypes:function(cname,join,on,where_,groupby,order_){
		if(this.base.cfg.DB_Type=="MSSQL")return ModelHelper.GetSqlsForMSSQL.apply(this,arguments);
		if(this.base.cfg.DB_Type=="MYSQL")return ModelHelper.GetSqlsForMysql.apply(this,arguments);
		if(this.base.cfg.DB_Type=="SQLITE")return ModelHelper.GetSqlsForMysql.apply(this,arguments);
		return ModelHelper.GetSqlsForAccess.apply(this,arguments);
	},
	GetSqlsForAccess:function(cname,join,on,where_,groupby,order_){
		var sql;
		if(this.isonlypkorder && this.ballowOnlyPKOrder){
			if(this.strpage>1){
				var c="<",d="min";
				if(this.onlypkorder.toLowerCase()=="asc") {c=">";d="max";}
				where_ +=" " + (where_!=""?"and":"where") + " " + (this.strcname==""?this.table:this.strcname) + "." + this.pagekey + c + " (select " + d + "(" + this.pagekey + ") from (select top " + this.strlimit * (this.strpage-1) + " " + (this.strcname==""?this.table:this.strcname) + "." + this.pagekey + " from " +this.joinlevel + this.table + cname + join + where_ + groupby+ order_ +") as mo_p_tmp)";
			}
			sql="select top " + this.strlimit + " " + this.fields + " from " + this.joinlevel + this.table + cname + join + where_ + groupby+ order_;
		}else{
			if(this.strpage>1)where_ +=" " + (where_!=""?"and":"where") + " " + (this.strcname==""?this.table:this.strcname) + "." + this.pagekey + " not in(select top " + this.strlimit * (this.strpage-1) + " " + (this.strcname==""?this.table:this.strcname) + "." + this.pagekey + " from " +this.joinlevel + this.table + cname + join + where_ + groupby+ order_ +")"	;
			sql="select top " + this.strlimit + " " + this.fields + " from " + this.joinlevel + this.table + cname + join + where_ + groupby+ order_;		
		}
		return sql;
	},
	GetSqlsForMSSQL:function(cname,join,on,where_,groupby,order_){
		if(this.base.cfg.DB_Version==2012){
			return "select " + this.fields + " from " + this.joinlevel + this.table + cname + join + where_ + groupby+ order_ +" OFFSET " + (this.strlimit * (this.strpage-1) +1) + " ROWS FETCH NEXT " + this.strlimit + " ROWS ONLY";
		}
		else if(this.base.cfg.DB_Version>=2005){
			return "select * from (select " + this.fields + ",ROW_NUMBER() OVER (" + order_ + ") AS ROWID_ from " + this.joinlevel + this.table + cname + join + where_ + groupby +") AS tmp_table_1 where ROWID_ BETWEEN " + (this.strlimit * (this.strpage-1) +1) + " and " + (this.strlimit * this.strpage);
		}
		var sql;
		if(this.isonlypkorder && this.ballowOnlyPKOrder){
			if(this.strpage>1){
				var c="<",d="min";
				if(this.onlypkorder.toLowerCase()=="asc") {c=">";d="max";}
				where_ +=" " + (where_!=""?"and":"where") + " " + (this.strcname==""?this.table:this.strcname) + "." + this.pagekey + c + " (select " + d + "(" + this.pagekey + ") from (select top " + this.strlimit * (this.strpage-1) + " " + (this.strcname==""?this.table:this.strcname) + "." + this.pagekey + " from " +this.joinlevel + this.table + cname + join + where_ + groupby+ order_ +") as mo_p_tmp)";
			}
			sql="select top " + this.strlimit + " " + this.fields + " from " + this.joinlevel + this.table + cname + join + where_ + groupby+ order_;
		}else{
			if(this.strpage>1)where_ +=" " + (where_!=""?"and":"where") + " " + (this.strcname==""?this.table:this.strcname) + "." + this.pagekey + " not in(select top " + this.strlimit * (this.strpage-1) + " " + (this.strcname==""?this.table:this.strcname) + "." + this.pagekey + " from " +this.joinlevel + this.table + cname + join + where_ + groupby+ order_ +")"	;
			sql="select top " + this.strlimit + " " + this.fields + " from " + this.joinlevel + this.table + cname + join + where_ + groupby+ order_;		
		}
		return sql;
	},
	GetSqlsForMysql:function(cname,join,on,where_,groupby,order_){
		if(this.isonlypkorder && this.ballowOnlyPKOrder){
			if(this.strpage>1){
				var c="<=";
				if(this.onlypkorder.toLowerCase()=="asc") c=">=";
				sql="select " + this.fields + " from " + this.joinlevel + this.table + cname + join + where_ + (where_!=""?" and ":" where ") + this.table +"." + this.pk + c
				+ "(select " + (this.strcname==""?this.table:this.strcname) +"." + this.pk + " from " + this.joinlevel + this.table + join + where_+ groupby+ order_ + " limit " + this.strlimit * (this.strpage-1) + ",1)"
				+ groupby+ order_ +" limit " + this.strlimit + "";
			}else{
				sql="select " + this.fields + " from " + this.joinlevel + this.table + cname + join + where_ + groupby+ order_ +" limit 0," + this.strlimit + "";
			}
		}else{
			sql="select " + this.fields + " from " + this.joinlevel + this.table + cname + join + where_ + groupby+ order_ +" limit " + this.strlimit * (this.strpage-1) + "," + this.strlimit + "";
		}
		return sql;
	},
	GetTables:function(){
		//http://support.microsoft.com/kb/186246/zh-cn
		var conn = this.base;
		var table_named_field_name="TABLE_NAME";
		var rs =null;
		if(this.cfg.DB_Type=="ACCESS") rs=conn.openSchema(20,F.vbs.eval("Array(Empty,Empty,Empty,\"Table\")"));
		if(this.cfg.DB_Type=="MSSQL") rs=conn.openSchema(20,F.vbs.eval("Array(\"" + this.cfg.DB_Name + "\",Empty,Empty,\"Table\")"));
		if(this.cfg.DB_Type=="SQLITE"){
			rs = conn.execute("select * from sqlite_master where type = 'table'");
			table_named_field_name = "name";
		}
		if(this.cfg.DB_Type=="MYSQL"){
			rs = conn.execute("show tables");
			table_named_field_name = "Tables_in_public";
		}
		if(rs==null)return null;
		var obj={},i=0;
		while(!rs.eof){
			var tablename = rs(table_named_field_name).Value;
			obj[tablename]=ModelHelper.GetColumns.call(this,tablename)
			rs.movenext();
		}
		return obj;
	},
	GetColumns:function(tablename){
		var conn = this.base;
		var rs =null;
		if(this.cfg.DB_Type=="ACCESS") rs = conn.openSchema(4,F.vbs.eval("Array(Empty,Empty,\"" + tablename + "\")"));
		if(this.cfg.DB_Type=="MSSQL") rs = conn.openSchema(4,F.vbs.eval("Array(\"" + this.cfg.DB_Name + "\",\"" + (this.cfg.DB_Owner||"dbo") + "\",\"" + tablename + "\")"));
		if(this.cfg.DB_Type=="SQLITE")rs = conn.execute("PRAGMA table_info(" + tablename + ")");
		if(this.cfg.DB_Type=="MYSQL")rs = conn.execute("show columns from `" + tablename + "`");
		if(rs==null)return null;
		var obj={},i=0;
		while(!rs.eof){
			if(this.cfg.DB_Type=="SQLITE"){
				obj[rs("name").Value]={
					"DATA_TYPE":rs.fields("type").Value,
					"IS_NULLABLE":rs.fields("notnull").Value==0,
					"IS_PK":rs.fields("pk").Value==1,
					"COLUMN_DEFAULT":rs.fields("dflt_value").Value
				};				
			}else if(this.cfg.DB_Type=="MYSQL"){
				obj[rs("Field").Value]={
					"DATA_TYPE":rs.fields("Type").Value,
					"IS_NULLABLE":rs.fields("Null").Value=="YES",
					"IS_PK":rs.fields("Key").Value=="PRI",
					"COLUMN_DEFAULT":rs.fields("Default").Value
				};				
			}else{
				var cname=rs("COLUMN_NAME").Value;
				obj[cname]={
					"DATA_TYPE":rs.fields("DATA_TYPE").Value,
					"COLUMN_FLAGS":rs.fields("COLUMN_FLAGS").Value,
					"IS_NULLABLE":rs.fields("IS_NULLABLE").Value,
					"COLUMN_DEFAULT":rs.fields("COLUMN_DEFAULT").Value,
					"NUMERIC_PRECISION":rs.fields("NUMERIC_PRECISION").Value,
					"NUMERIC_SCALE":rs.fields("NUMERIC_SCALE").Value,
					"CHARACTER_MAXIMUM_LENGTH":rs.fields("CHARACTER_MAXIMUM_LENGTH").Value
				};
				if(obj[cname].DATA_TYPE==130){
					if(obj[cname].COLUMN_FLAGS>>7 ==1){
						obj[cname].CHARACTER_MAXIMUM_LENGTH=1024000;
					}
				}
			}
			rs.movenext();
		}
		return obj;
	}
};
function ModelCMDManager(cmd,model,ct){
	this.cmd = cmd ||"";
	this.model = model || null;
	this.parms_={};
	this.cmdobj=F.activex("ADODB.Command");
	this.cmdobj.ActiveConnection=model.getConnection();
	this.cmdobj.CommandType=ct||4;
    this.cmdobj.Prepared = true;
    this.withQuery=true;
    this.parmsGet=false;
    this.totalRecordsParm="";
}
ModelCMDManager.New = function(cmd,model,ct){return new ModelCMDManager(cmd,model,ct);};
ModelCMDManager.prototype.addParm = function(name,value,direction){
	this.parms_[name] = this.cmdobj.CreateParameter(name);
	this.parms_[name].Value = value||null;
	this.parms_[name].Direction = direction||1;
	return this.parms_[name];
}
ModelCMDManager.prototype.addInput = function(name,value,t,size){
	this.parms_[name] = this.cmdobj.CreateParameter(name, t, ModelHelper.Enums.ParameterDirection.INPUT, size, value||null);
	return this.parms_[name];
}
ModelCMDManager.prototype.addInputInt = function(name,value){
	this.addInput(name,value,ModelHelper.Enums.DataType.DBTYPE_I4,4);
}
ModelCMDManager.prototype.addInputBigInt = function(name,value){
	this.addInput(name,value,ModelHelper.Enums.DataType.DBTYPE_I8,8);
}
ModelCMDManager.prototype.addInputVarchar = function(name,value,size){
	this.addInput(name,value,ModelHelper.Enums.DataType.VARCHAR,size||50);
}
ModelCMDManager.prototype.addOutput = function(name,t,size){
	this.parms_[name] = this.cmdobj.CreateParameter(name, t, ModelHelper.Enums.ParameterDirection.OUTPUT, size);
	return this.parms_[name];
}
ModelCMDManager.prototype.addReturn = function(name,t,size){
	this.parms_[name] = this.cmdobj.CreateParameter(name, t, ModelHelper.Enums.ParameterDirection.RETURNVALUE, size);
	return this.parms_[name];
}
ModelCMDManager.prototype.getparm = function(name){
	if(!this.parmsGet){
		for(var i in this.parms_){
			if(!this.parms_.hasOwnProperty(i))continue;
			if(this.parms_[i].Type>1){
				this.parms_[i].value = this.cmdobj(i).value;
			}
		}
		this.parmsGet=true;
	}
	if(!this.parms_.hasOwnProperty(name)) return null;
	return this.parms_[name];
}
ModelCMDManager.prototype.execute = function(withQuery){
	this.withQuery = withQuery===true;
	this.model.exec(this);
	return this.model;
};
ModelCMDManager.prototype.assign = function(name,asobject){
	return this.model.assign(name,asobject);
};
ModelCMDManager.prototype.exec = function(){
	this.cmdobj.CommandText = this.cmd;
	for(var i in this.parms_){
		if(!this.parms_.hasOwnProperty(i))continue;
		this.cmdobj.Parameters.Append(this.parms_[i]);
	}
	if(this.withQuery){
		return Model__.RecordsAffectedCmd(this.cmdobj,true);
	}else{
		Model__.RecordsAffectedCmd(this.cmdobj,false);
	}
}
</script>