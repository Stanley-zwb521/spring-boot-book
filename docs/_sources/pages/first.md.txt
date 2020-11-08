###################################
开始第一个Spring Boot应用程序
###################################

Spring Boot 是由 Pivotal 团队提供用来简化 Spring 的搭建和开发过程的全新框架。随着近些年来微服务技术的流行，Spring Boot 也成了时下炙手可热的热点技术。

Spring Boot 去除了大量的 xml 配置文件，简化了复杂的依赖管理，配合各种 starter 使用，基本上可以做到自动化配置。Spring 可以做的事情，现在用 Spring boot 都可以做。

这套 Spring Boot 框架快速入门教程以大量示例讲解了 Spring Boot 在各类情境中的应用，让读者可以跟着笔者的思维和代码快速理解并掌握。适用于 Java 开发人员，尤其是初学 Spring Boot 的人员和需要从传统 Spring 转向 Spring Boot 开发的技术人员。

Spring Boot 概述
=====================================

* 创建独立的Spring应用程序
* 直接嵌入Tomcat，Jetty或Undertow（无需部署WAR文件）
* 提供集成的“starter”依赖项，以简化构建配置
* 尽可能自动配置Spring和3rd Party库
* 提供生产就绪的功能，例如指标，运行状况检查和外部配置
* 完全没有代码生成，也不需要XML配置（最低配置或零配置）
* 约定大于配置（Convention Over Configuration）


Spring Boot CLI
=====================================
Spring Boot CLI是一个命令行工具，使用它可以快速开发Spring应用。Spring Boot CLI基于运行Groovy脚本，Groovy是一个类似Java的语法的语言。我们也可以基于Spring Boot CLI编写自己的命令。

安装Spring Boot CLI
************************

Mac上安装
------------
推荐Manual Installation方式安装。

1. 下载 `spring-boot-cli-2.3.3.RELEASE-bin.zip <https://repo.spring.io/release/org/springframework/boot/spring-boot-cli/2.3.3.RELEASE/spring-boot-cli-2.3.3.RELEASE-bin.zip>`__ 文件 
2. 解压文件到任何目录
3. 创建软链接，如::

    ln -s /work/tool/spring-2.3.3.RELEASE/bin/spring /usr/local/bin/spring

其他系统上安装
------------------
参照连接：
https://docs.spring.io/spring-boot/docs/current/reference/html/getting-started.html#getting-started-installing-the-cli


开始使用CLI
************************
验证安装是否成功，运行命令：
 
 .. code-block:: sh
    :linenos:

    $ spring --version
    Spring CLI v2.3.3.RELEASE

下面通过一个示例，快速的使用CLI。

1. 创建文件 app.groovy::

    @RestController
    class ThisWillActuallyRun {

        @RequestMapping("/")
        String home() {
            "Hello World!"
        }

    }

2. 然后从CLI运行它，如下所示::

    spring run app.groovy

在浏览器中打开 http://localhost:8080 。应该会看到输出"Hello World!"。

使用CLI初始化项目
************************
::

    $ spring init --dependencies=web,data-jpa my-project
    Using service at https://start.spring.io
    Project extracted to '/Users/developer/example/my-project'


创建一个 Hello World 应用
=====================================

环境准备
*********

 确保本地安装了有效的Java和Maven版本::

    $ java -version
    java version "1.8.0_102"
    Java(TM) SE Runtime Environment (build 1.8.0_102-b14)
    Java HotSpot(TM) 64-Bit Server VM (build 25.102-b14, mixed mode)

    $ mvn -v
    Apache Maven 3.5.4 (1edded0938998edf8bf061f1ceb3cfdeccf443fe; 2018-06-17T14:33:14-04:00)
    Maven home: /usr/local/Cellar/maven/3.3.9/libexec
    Java version: 1.8.0_102, vendor: Oracle Corporation


在线界面初始化项目
*******************
https://start.spring.io/


pom.xml
******************
Spring Boot提供了许多 "Starters（启动程序）"，目的是可以将jar添加到classpath中。spring-boot-starter-parent是一个特殊的启动程序，它除了提供了Maven的默认值外，还提供了依赖管理，这样就可以省略依赖的版本标签。

<relativePath> 标签的作用是设置依赖查找的顺序，默认路径为：relativePath元素中的地址->本地仓库–>远程仓库。当设置为空时，即：<relativePath/> 表示依赖不从该元素中的地址（本地路径）获取，直接从仓库（本地仓库–>远程仓库）获取。

其他 "Starters"提供了开发特定类型应用时可能需要的依赖关系。由于我们要开发的是一个Web应用，所以我们添加一个spring-boot-starter-web依赖：

.. code-block:: xml

    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>

我们可以通过运行下面的命令来查看当前应用依赖的Jar包及其依赖关系::

    mvn dependency:tree

``mvn dependency:tree`` 命令打印项目依赖关系树信息。

添加Code
*************
打开 Application.java 类，添加一个方法和一个annotation（代码高亮部分）:

.. code-block:: java
    :linenos:
    :emphasize-lines: 5-6,8,12-15

    package com.example.demo;

    import org.springframework.boot.SpringApplication;
    import org.springframework.boot.autoconfigure.SpringBootApplication;
    import org.springframework.web.bind.annotation.RequestMapping;
    import org.springframework.web.bind.annotation.RestController;

    @RestController
    @SpringBootApplication
    public class DemoApplication {

        @RequestMapping("/")
        String home() {
            return "Hello World!";
        }

        public static void main(String[] args) {
            SpringApplication.run(DemoApplication.class, args);
        }

    }


1. @RestController 这个注解提供了处理传入的Web请求和返回JSON响应。 
2. @RequestMapping 这个注解提供路由设置。 
3. main方法 这只是遵循Java约定的应用程序入口点的标准方法。 我们的main方法通过调用run委托给Spring Boot的SpringApplication类。 SpringApplication会引导我们的应用程序，并启动Spring，后者反过来又会启动自动配置的Tomcat Web服务器。 

运行程序
*************
介绍2种方式运行程序。

IDE中执行
----------
导入到Eclipse中，然后直接运行DemoApplication类中的main方法。

mvn执行
----------
在POM文件种，程序依赖了spring-boot-starter-parent, 用它来启动应用程序::

    mvn spring-boot:run

打开浏览器，访问 http://localhost:8080, 将会看到下面的输出::

    Hello World!


对比 Maven 和 Gradle
=====================================

Maven
***********
Maven的核心可以说是一个Plugin（插件）执行框架，因为所有的工作都是由Plugin来完成的。Maven支持广泛的可用Plugin，而且每个Plugin都可以额外配置。

其中一个可用的插件是Apache Maven Dependency Plugin，它有一个copy-dependencies（复制-依赖）的goal（目标），将项目的依赖复制到指定的目录。
为了展示这个插件的作用，我们在pom.xml文件中加入这个插件，并为项目的依赖关系配置一个输出目录。

.. code-block:: xml
    :linenos:
        
    <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-dependency-plugin</artifactId>
        <executions>
            <execution>
                <id>copy-dependencies</id>
                <phase>package</phase>
                <goals>
                    <goal>copy-dependencies</goal>
                </goals>
                <configuration>
                    <outputDirectory>target/dependencies
                    </outputDirectory>
                </configuration>
            </execution>
        </executions>
    </plugin>

这个插件将在“package”阶段执行，所以如果我们运行命令::

    mvn package

package将执行这个插件，并将依赖项复制到“target/dependencies”文件夹中。

Maven变得非常流行，因为现在构建文件已经标准化了，相比Ant，维护构建文件的时间大大减少。不过，虽然比Ant文件更标准化，但Maven的配置文件还是容易变得很大很繁琐。

Maven的严格约定的代价是灵活性比Ant差很多。目标自定义非常难，所以写自定义的构建脚本相比Ant来说，难度要大很多。

虽然Maven在让应用的构建过程变得更简单、更标准化方面做了一些严重的改进，但由于比Ant少了很多灵活性，它仍然是有代价的。这就导致了Gradle的诞生，它结合了Ant的灵活性和Maven的功能。

Gradle是一个依赖性管理和构建自动化工具，它是建立在Ant和Maven的概念上的。

关于Gradle，它使用的是基于Groovy或Kotlin的一门DSL（Domain-Specific Language）语言，因为该语言是专门为解决特定领域问题而设计的。Gradle不像Ant或Maven，不使用XML文件。Gradle的配置文件在Groovy中约定俗成地称为build.gradle，在Kotlin中称为build.gradle.kts。

Gradle
***********
下面通过在线界面初始化一个Gradle项目，其build.gradle内容如下：

.. code-block:: groovy
    :linenos:

    plugins {
        id 'org.springframework.boot' version '2.3.3.RELEASE'
        id 'io.spring.dependency-management' version '1.0.10.RELEASE'
        id 'java'
    }

    group = 'com.example'
    version = '0.0.1-SNAPSHOT'
    sourceCompatibility = '8'

    repositories {
        mavenCentral()
    }

    dependencies {
        implementation 'org.springframework.boot:spring-boot-starter-web'
        testImplementation('org.springframework.boot:spring-boot-starter-test') {
            exclude group: 'org.junit.vintage', module: 'junit-vintage-engine'
        }
    }

    test {
        useJUnitPlatform()
    }

我们可以通过运行下面的命令对项目进行编译::

    gradle classes

Gradle的配置文件看上去显然比Maven要少很多。在上面的Maven项目示例中，我们使用Apache Maven Dependency Plugin 将依赖关系复制到指定的目录中，下面我们在Gradle中实现同样的功能。

Gradle给它的构建步骤命名为 "tasks（任务）"，而不是Ant的 "targets(目标) "或Maven的 "phases(阶段)"。在Gradle中，我们可以通过使用task任务来实现同样的目标。

.. code-block:: groovy
    :linenos:

    task copyDependencies(type: Copy) {
        from configurations.default
        into 'dependencies'
    }

接着，我们执行下面的命令：

.. code-block:: sh
    :linenos:

    $ gradle copyDependencies
    Starting a Gradle Daemon, 1 incompatible and 1 stopped Daemons could not be reused, use --status for details

    Deprecated Gradle features were used in this build, making it incompatible with Gradle 7.0.
    Use '--warning-mode all' to show the individual deprecation warnings.
    See https://docs.gradle.org/6.6.1/userguide/command_line_interface.html#sec:command_line_warnings

    BUILD SUCCESSFUL in 8s

上述命令执行完成后，将会在项目的根目录下自动生成了一个“dependencies”命名的文件名，里面包含了项目的全部依赖包。


IDE Support
=====================================
常规的IDE有：Eclipse, STS 和 IntelliJ，下面示图显示的是导入Gradle或者Maven项目到Eclipse中的选项面板。

 .. image:: images/import.png
    :width: 600px

Spring boot 的自动配置
=====================================
Spring Boot 自动配置会尝试根据添加的 jar 依赖项，自动配置 Spring 应用程序。例如，如果HSQLDB（一个嵌入式内存数据库）在 Classpath 上，并且项目尚未手动配置任何数据库连接 bean，那么 Spring Boot 会自动配置内存数据库。

用户需要通过向@Configuration类上添加@EnableAutoConfiguration或@SpringBootApplication 标签来选择自动配置。

自动配置是非侵入性的。在任何时候，用户都可以开始定义自己的配置，以替换自动配置的特定部分。例如，如果用户添加自己的DataSource bean，则默认的嵌入式数据库支持将退出。

打包 Spring Boot 应用程序
=====================================

Maven 工程
***************
mvn package

Gradle 工程
****************
gradle build

运行及部署 Spring Boot 应用程序
=====================================
上述通过打包 Spring Boot 应用程序后，将创建可执行（Executable）Jar包。可执行Jar包可以在生产环境中完全独立的运行。
可执行jar（有时称为“fat jar”）是包含已编译类以及代码需要运行的所有jar依赖项的归档文件。

mvn package 命令在目标目录下生成了一个类似名为“demo-0.0.1-SNAPSHOT.jar”的文件。这个文件的大小应该在10MB左右。如果查看Jar包里面的内容，可以使用如下命令::

    jar tvf target/demo-0.0.1-SNAPSHOT.jar

执行上述命令后，在目录下看到一个小得多的文件，名为 demo-0.0.1-SNAPSHOT.jar.original。这是Maven在被Spring Boot重新打包之前创建的原始jar文件。

要运行该应用程序，请使用java -jar命令，如下所示::

    java -jar target/demo-0.0.1-SNAPSHOT.jar

可以通过快捷键停止应用： Ctrl + c 。

上述命令，一旦关闭命令框，程序将会终止，这时可以使用如下命令::

    nohup java -jar your_app.jar --server.port=8888 &

通过nohup 和 & 组合，将命令转向后台，这时关闭命令框，程序将不受影响，依然持续运行。

参考
=========
#. 中文：https://www.docs4dev.com/docs/zh/spring-boot/2.1.1.RELEASE/reference
#. 英文：https://docs.spring.io/spring-boot/docs/current/reference/html/getting-started.html#getting-started
#. https://www.tutorialspoint.com/spring_boot/index.htm