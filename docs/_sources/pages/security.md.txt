###################################
Security with Spring Boot
###################################

关键词
==============
#. 认证就是确认用户的身份
#. principal 主体
#. credential 凭据，如： user ID 和 password
#. social login 社交登录，如：Github, Google
#. OAuth 2: `OAuth 2.0 的四种方式 <https://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html>`__
#. OpenID Connect 是建立在OAuth 2.0协议之上的身份识别层

Spring Security
=============================================

Security with Spring Boot
=============================================

Fundamental Elements
=============================================

Spring Security Managers
=============================================

Spring Web Applications
=============================================

Other Authentication providers
=============================================

Configuring Spring for Security
=============================================

Method Security
=============================================

Defining Method level Security
=============================================

Annotation Based Method Security
=============================================

Alternative Annotations
=============================================


Single Sign On With GitHub
=================================
下面利用Spring Boot中的自动配置功能，创建一个使用GitHub进行身份验证的最小应用程序。

创建一个新项目
****************
首先，创建一个Spring Boot Web 应用程序，这可以通过多种方式来完成。最简单的方法是访问 https://start.spring.io ，然后生成一个空项目（选择 "Web "依赖关系作为起点）。同样，在命令行上也可以这样做:

.. code-block:: sh

    $ curl https://start.spring.io/starter.zip -d dependencies=web,devtools -o my-project.zip
    $ tar -xzvf my-project.zip 

然后，将该项目导入到你最喜欢的IDE中（默认是一个普通的Maven Java项目）。

添加webjars依赖
*********************
添加jQuery 和 Bootstrap依赖包：

.. code-block:: xml

    <dependency>
        <groupId>org.webjars</groupId>
        <artifactId>jquery</artifactId>
        <version>3.4.1</version>
    </dependency>
    <dependency>
        <groupId>org.webjars</groupId>
        <artifactId>bootstrap</artifactId>
        <version>4.3.1</version>
    </dependency>
    <dependency>
        <groupId>org.webjars</groupId>
        <artifactId>webjars-locator-core</artifactId>
    </dependency>


最后一个依赖是webjars locator，它是由webjars网站提供的一个库。Spring可以使用locator来定位webjars中的静态资产，而不需要知道确切的版本
（因此index.html中才有无版本的/webjars/ 链接）。在Spring Boot应用程序中，只要你不关闭MVC自动配置，webjar定位器就会被默认激活。



添加首页面
****************

在项目中的 src/main/resources/static 文件夹中创建 index.html。添加一些样式表和JavaScript链接，使结果看起来像这样：


.. code-block:: html

    <!doctype html>
    <html lang="en">
    <head>
        <meta charset="utf-8"/>
        <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
        <title>Demo</title>
        <meta name="description" content=""/>
        <meta name="viewport" content="width=device-width"/>
        <base href="/"/>
        <link rel="stylesheet" type="text/css" href="/webjars/bootstrap/css/bootstrap.min.css"/>
        <script type="text/javascript" src="/webjars/jquery/jquery.min.js"></script>
        <script type="text/javascript" src="/webjars/bootstrap/js/bootstrap.min.js"></script>
    </head>
    <body>
        <h1>Demo</h1>
        <div class="container"></div>
    </body>
    </html>

添加Spring Security oauth2 依赖
*************************************

.. code-block:: xml

    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-oauth2-client</artifactId>
    </dependency>


添加一个新的GitHub应用程序
*************************************

要使用GitHub的OAuth 2.0认证系统进行登录，必须先 `添加一个新的GitHub应用 <https://github.com/settings/developers>`__ 。

选择 "New OAuth App（新建OAuth应用）"，然后出现 "Register a new OAuth application（注册一个新的OAuth应用） "页面。输入应用名称和描述。然后，输入你的应用的主页，本例中应该是http://localhost:8080。最后，注明授权回调网址为http://localhost:8080/login/oauth2/code/github，然后点击注册应用。

OAuth重定向URI是终端用户的用户代理在GitHub上进行身份验证，并在授权应用页面上授权访问应用后，重定向回应用中的路径。


配置application.yml文件内容
*************************************

.. code-block:: yaml

    spring:
      security:
        oauth2:
          client:
            registration:
              github:
                clientId: github-client-id
                clientSecret: github-client-secret


只需使用刚刚在 GitHub 创建的 OAuth 2.0 凭证，将 github-client-id 替换为：client id，将 github-client-secret 替换为：client secret。

再次运行你的应用程序并访问主页http://localhost:8080。现在，你应该被重定向到用GitHub登录，而不是index首页。接受任何要求你做的授权，你将被重定向回本地应用程序的index首页。


如果你登录过GitHub，即使你在一个没有Cookie和缓存数据的全新浏览器中打开它，你也不必重新认证这个本地应用程序。这就是单点登录。


到目前为止，用OAuth 2.0的术语来说，我们当完成的是一个客户端应用，它使用授权码授予从GitHub（授权服务器）获得一个访问令牌。

然后，它使用访问令牌向GitHub询问一些个人信息（只有你允许它做的事情），包括你的登录ID和你的名字。在这个阶段，GitHub是作为一个资源服务器，对你发送的令牌进行解码，并检查它是否允许应用程序访问用户的详细信息。如果该过程成功，应用程序会将用户详细信息插入Spring Security context 上下文中，这样你就通过了认证。

如果你在浏览器工具中查看（Chrome或Firefox上的F12），并跟踪所有跳转的网络流量，你会看到与GitHub来回的重定向，最后你会回到主页，并有一个新的Set-Cookie header头。这个cookie（默认情况下是JSESSIONID）是你在Spring（或任何基于servlet的）应用程序中的身份验证详细信息的令牌。


因此，我们有一个安全的应用程序，在某种意义上，用户要看到任何内容，必须与外部供应商（GitHub）进行认证。

我们不会想把它用在一个网银网站上。但对于基本的身份识别目的，以及为了在你的网站的不同用户之间隔离内容，这是一个很好的起点。这就是为什么现在这种身份验证非常流行的原因。

在下一节中，我们将为应用程序添加一些基本功能。我们也会让用户在收到GitHub的初始重定向时，更清楚地知道发生了什么。

添加一个欢迎页面
**********************
在本节中，你将修改刚刚构建的简单应用，添加一个显式链接来登录GitHub。新的链接不会立即被重定向，而是会在主页上显示，用户可以选择登录或保持未认证状态。只有当用户点击了该链接后，安全内容才会呈现。

要在用户经过认证的条件下渲染内容，你可以选择服务器端或客户端渲染。

要开始使用动态内容，你需要像这样标记几个HTML元素：

.. code-block:: html

    <div class="container unauthenticated">
        With GitHub: <a href="/oauth2/authorization/github">click here</a>
    </div>
    <div class="container authenticated" style="display:none">
        Logged in as: <span id="user"></span>
    </div>


默认情况下，第一个<div>会显示，第二个不会。还请注意带有id属性的空<span>。

稍后，你将添加一个服务器端endpoint（端点），它将以JSON形式返回已登录用户的详细信息。

但是，首先，添加下面的JavaScript，它将接收端点的响应，这个JavaScript将用用户的名字填充<span>标签，并适当地切换<div>。

.. code-block:: html

    <script type="text/javascript">
        $.get("/user", function(data) {
            $("#user").html(data.name);
            $(".unauthenticated").hide()
            $(".authenticated").show()
        });
    </script>

请注意，这个JavaScript期望接收来自服务器端的endpoint（端点）“/user”。


添加服务器端endpoint（端点）“/user”
**************************************
现在，将添加刚才提到的服务器端endpoint（端点）“/user”。它将发送回当前登录的用户，我们可以在我们的主类中很容易地做到这一点。

.. code-block:: java

    @SpringBootApplication
    @RestController
    public class SocialApplication {

        @GetMapping("/user")
        public Map<String, Object> user(@AuthenticationPrincipal OAuth2User principal) {
            return Collections.singletonMap("name", principal.getAttribute("name"));
        }

        public static void main(String[] args) {
            SpringApplication.run(SocialApplication.class, args);
        }

    }


这个应用现在会像以前一样正常工作和认证，但它仍然会在显示页面之前重定向。为了使链接可见，我们还需要通过扩展WebSecurityConfigurerAdapter来关闭主页上的安全性。


.. code-block:: java

    @SpringBootApplication
    @RestController
    public class SocialApplication extends WebSecurityConfigurerAdapter {

        // ...

        @Override
        protected void configure(HttpSecurity http) throws Exception {
            // @formatter:off
            http
                .authorizeRequests(a -> a
                    .antMatchers("/", "/error", "/webjars/**").permitAll()
                    .anyRequest().authenticated()
                )
                .exceptionHandling(e -> e
                    .authenticationEntryPoint(new HttpStatusEntryPoint(HttpStatus.UNAUTHORIZED))
                )
                .oauth2Login();
            // @formatter:on
        }

    }

Spring Boot 在用 @SpringBootApplication 注解的类上为 WebSecurityConfigurerAdapter 附加了特殊的含义。它用它来配置承载OAuth 2.0认证处理器的安全过滤链。

上述配置表示允许的端点的白名单，其他每个端点都需要认证。


由于我们是通过Ajax与后端进行交互，所以我们希望配置端点以401来响应，而不是默认的重定向到登录页面的行为。配置authenticationEntryPoint就可以实现这一点。

完成这些改动后，应用程序就完成了，如果你运行它并访问主页，你应该会看到一个样式精美的 HTML 链接，指向 "登录 GitHub"。这个链接不是直接带你到GitHub，而是带你到处理认证的本地路径（并发送一个重定向到GitHub）。一旦你进行了身份验证，你就会被重定向回本地应用，现在它将显示你的名字（假设你在GitHub中设置了允许访问这些数据的权限）。

添加一个Logout按钮
****************************
在本节中，我们修改我们构建的点击应用，增加一个按钮，让用户可以退出应用。这看起来是一个简单的功能，但实现起来需要一点小心，所以值得花点时间讨论一下具体怎么做。大部分的改变都是与我们将应用从只读资源转化为读写资源（注销需要改变状态）有关，所以在任何现实的应用中，如果不只是静态内容，也需要同样的改变。

在客户端，我们只需要提供一个注销按钮和一些JavaScript来回调服务器，要求取消认证。首先，在UI的 "authenticated（已认证） "部分，我们添加按钮。

.. code-block:: html

    <div class="container authenticated">
    Logged in as: <span id="user"></span>
    <div>
        <button onClick="logout()" class="btn btn-primary">Logout</button>
    </div>
    </div>

然后我们在JavaScript中提供它所引用的logout()函数。


.. code-block:: javascript

    var logout = function() {
        $.post("/logout", function() {
            $("#user").html('');
            $(".unauthenticated").show();
            $(".authenticated").hide();
        })
        return true;
    }

logout()函数对“/logout”做一个POST请求，然后清除动态内容。现在我们可以切换到服务器端来实现这个端点。

添加服务器端endpoint（端点）“/logout”
**************************************
Spring Security已经内置了对/logout端点的支持，它将为我们做正确的事情（清除会话并使cookie无效）。要配置端点，我们只需在WebSecurityConfigurerAdapter中扩展现有的configure()方法。

.. code-block:: java

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        // @formatter:off
        http
            // ... existing code here
            .logout(l -> l
                .logoutSuccessUrl("/").permitAll()
            )
            // ... existing code here
        // @formatter:on
    }


我们需要对“/logout”端点进行POST请求，为了保护用户免受跨站请求伪造（CSRF），它需要在请求中包含一个令牌。令牌的值与当前会话相关联，而当前会话是提供保护的，所以我们需要一种方法将这些数据获取到我们的JavaScript应用中。

许多JavaScript框架已经内置了对CSRF的支持（例如在Angular中，他们称之为XSRF），但它的实现方式通常与Spring Security的开箱行为略有不同。例如，在Angular中，前端希望服务器给它发送一个名为 "XSRF-TOKEN "的cookie，如果它看到了，就会把这个值作为一个名为 "X-XSRF-TOKEN "的头发送回来。我们可以用我们简单的jQuery客户端来实现同样的行为，然后服务器端的变化就可以和其他前端实现一起工作，不需要或很少需要改变。为了教给Spring Security这个问题，我们需要添加一个创建cookie的过滤器。

首先，加入js-cookie库依赖：

.. code-block:: xml

    <dependency>
        <groupId>org.webjars</groupId>
        <artifactId>js-cookie</artifactId>
        <version>2.1.0</version>
    </dependency>

然后，在WebSecurityConfigurerAdapter中，我们添加如下代码：

.. code-block:: java

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        // @formatter:off
        http
            // ... existing code here
            .csrf(c -> c
                .csrfTokenRepository(CookieCsrfTokenRepository.withHttpOnlyFalse())
            )
            // ... existing code here
        // @formatter:on
    }

最后，在index页面中添加js引用：

.. code-block:: html

    <script type="text/javascript" src="/webjars/js-cookie/js.cookie.js"></script>

并且使用可以使用XHR中的Cookies便利方法：

.. code-block:: html

    $.ajaxSetup({
    beforeSend : function(xhr, settings) {
        if (settings.type == 'POST' || settings.type == 'PUT'
            || settings.type == 'DELETE') {
        if (!(/^http:.*/.test(settings.url) || /^https:.*/
            .test(settings.url))) {
            // Only send the token to relative URLs i.e. locally.
            xhr.setRequestHeader("X-XSRF-TOKEN",
            Cookies.get('XSRF-TOKEN'));
        }
        }
    }
    });


到此为止，我们已经准备好运行应用程序并尝试新的注销按钮。启动应用程序并在新的浏览器窗口中加载主页。点击 "登录 "链接，将你带到GitHub（如果你已经在那里登录，你可能不会注意到重定向）。点击 "注销 "按钮来取消当前会话，并将应用程序返回到未认证状态。如果你很好奇，你应该能够在浏览器与本地服务器交换的请求中看到新的Cookie和头。



幸运的是，对于这样一个简单的用例，Spring Boot提供了一个简单的扩展点：如果你声明一个类型为OAuth2UserService的@Bean，它将被用来识别用户委托人。你可以使用这个钩子来断定用户是否在正确的组织中，如果不在，则抛出一个异常。

请注意，这段代码依赖于 WebClient 实例来代表已认证的用户访问 GitHub API。做完这些后，它会在组织中循环，寻找符合 "spring-projects "的组织（这是用来存储Spring开源项目的组织）。如果你希望能够成功认证，并且你不在Spring工程团队中，你可以在那里替换自己的值。如果没有匹配，它会抛出一个OAuth2AuthenticationException，这将被Spring Security接收并转为401响应。

参考
==========
#. https://github.ibm.com/lanzejun/w3id