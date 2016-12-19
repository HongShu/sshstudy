# summernote前端文本编辑器的用法

## 基本使用步骤：

1.导入bootstrap的css文件和js文件

2.导入jquery文件

3.导入summernote的css文件和js文件

4.添加一个div标签，在div上调用summernote()方法;

```html
<div id="editor">
    		Hello world!
</div>
```

```javascript
$(document).ready(function(){
  	$("#editor").summernote();
});
```

## 工具栏中文提示

```javasc
<script src="summernote/lang/summernote-zh-CN.js"></script>
$("#editor").summernote({lang:'zh-CN'});
还是乱码，js文件确实是utf-8格式存储的。在myeclipse打开也正常，但是在chrome下老是乱码，safari正常。
```



## 结合服务器端使用

>  默认情况下：在summernote中插入图片是，它会采用base-？？编码，讲图片数据添加到表单元素中。为了实现真正的添加操作，我们需要在上传图片的时候，将图片传递给服务器端存起来，然后在生成的html代码中，插入imge标签。

### 1.注意事项：

在myeclipse下面测试时，采用外部的tomcat，否则无法手动查看上传文件。

### 2.客户端实现：使用ajax实现图片上传

```javascript
$(document).ready(function(){
  $("#editor").summernote({
    callbacks:{
      onImageUpload: function(files) {
        var $editor = $(this);
        // 构建一个 form 数据
        var data = new FormData()
        //struts2的action中使用myFile的属性名
        data.append('myFile', files[0])			

        $.ajax({         // 上传文件到服务器端
          url: 'upload',			//struts2的UploadAction的映射路径
          method: 'POST',
          data: data,				
          processData: false,      // 这两个比较关键，禁止处理 form 数据
          contentType: false,       
          success: function(data) {
            //返回的数据是json字符串格式，但请求头部并不是json，所以需要用eval将字符串转成对象
            var temp =  eval ("(" + data + ")");	
            var imgURL = temp.url;   // 获取服务端返回的图片地址
            // 插入图片
            $editor.summernote('insertImage', imgURL);
            //需要进一步调整，让struts2的上传文件方法返回一个json，该json中存放上传成功的图片所在的路径。
            //重构项目，让本项目对bootstrap的应用更简单些。
          }
        });
      }
    }	
  })
});
```

### 3.服务器端实现：

```java
public class UploadAction extends ActionSupport {
	private File myFile;
	private String myFileContentType;
	private String myFileFileName;
	private String destPath;
	public String execute() {
         //获取webapps目录下的／upload在服务器上的绝对路径
		destPath = ServletActionContext.getServletContext().getRealPath("/upload");
		String fileName = null;
		File destFile = null;
		try {
			System.out.println("Src File name: " + myFile);
			System.out.println("Dst File name: " + myFileFileName);
            //文件名由当前日期的long决定，尤其完善应该将后缀名也做一些处理
			fileName = new Date().getTime()+".jpg";
			destFile = new File(destPath, fileName);
			FileUtils.copyFile(myFile, destFile);
		} catch (IOException e) {
			e.printStackTrace();
			return ERROR;
		}
      //图片上传到upload目录之后，访问路径是什么？几种路径还要进一步研究。
		String result = ServletActionContext.getServletContext().getContextPath()+"/upload/"+fileName;
	//直接硬编码，返回一个json格式的字符串	
      ServletActionContext.getRequest().setAttribute("data", "{url:\""+result+"\"}");  		
		return SUCCESS;
	}
}

//上面的action处理完后，会跳转到upload-success.jsp页面，该页面内容为
<%@ page language="java" import="java.util.*" pageEncoding="GB18030"%>
 ${data} 
```

## 服务器端实现：struts2默认返回一个json格

```javascript
$(document).ready(function(){
  $("#editor").summernote({
    lang:'zh-CN',			//中文
    callbacks:{
      onImageUpload: function(files) {
        var $editor = $(this);
        // 构建一个 form 数据
        var data = new FormData()
        // 增加一个字段 fileup 值是待上传的文件的内容
        data.append('myFile', files[0])//struts2的action中使用myFile的属性名
        $.ajax({         // 上传文件到服务器端
          url: 'up',
          method: 'POST',
          data: data,
          processData: false,      // 这两个比较关键，禁止处理 form 数据
          contentType: false,      // 
          success: function(data) {
            console.log(data);
            $editor.summernote('insertImage', data);
          }
        });
      }
    }	
  })
});
```

```java
public class UploadAction extends ActionSupport {
	private File myFile;
	private String myFileContentType;
	private String myFileFileName;
	private String destPath;
	private String imgUrl;//文件上传到服务器之后的路径
	public String getImgUrl() {
		return imgUrl;
	}

	public void setImgUrl(String imgUrl) {
		this.imgUrl = imgUrl;
	}
	public String execute() {
		destPath = ServletActionContext.getServletContext().getRealPath("/upload");
		String fileName = null;
		File destFile = null;
		try {
			System.out.println("Src File name: " + myFile);
			System.out.println("Dst File name: " + myFileFileName);
			fileName = ""+new Date().getTime()+".jpg";
			 destFile = new File(destPath, fileName);			
			FileUtils.copyFile(myFile, destFile);
		} catch (IOException e) {
			e.printStackTrace();
			return ERROR;
		}
		imgUrl =  ServletActionContext.getServletContext().getContextPath()+"/upload/"+fileName;
		System.out.println(imgUrl);
		return SUCCESS;
	}
```

```xml
<package name="my" extends="json-default">
    <action name="up" class="cn.struts2.UploadAction">
   		<param name="destPath">/upload</param>
        <result type="json">
        		<param name="root">imgUrl</param>		<!--只需要将该字段的值加入到json中-->
        </result>
   </action> 
</package>
```

