###################################
Spring Boot 概览
###################################

Spring Boot是专门用来运行独立的Spring应用的，和简单的Java应用一样，使用java -jar命令。Spring Boot与标准Spring配置不同的基本一点就是简单。这种简单性与我们需要了解的第一个重要术语密切相关，那就是Starter（启动器）。启动器是一个可以包含在项目依赖中的Artifact（人工制品）。它只不过是为其他Artifact提供了一组依赖关系，这些Artifact必须包含在你的应用程序中，以实现所需的功能。以这种方式交付的包已经可以使用了，这意味着我们不需要配置任何东西来使它工作。这就涉及到与Spring Boot相关的第二个重要术语，自动配置。所有的Starter所包含的Artifact都有默认设置，可以使用属性或其他类型的启动器轻松覆盖。例如，如果你在应用依赖中包含spring-boot-starter-web，它就会嵌入一个默认的web容器，并在应用启动时在默认端口上启动它。比如，Spring Boot中默认的web容器是Tomcat，它的启动端口是8080。我们可以通过在应用程序属性文件中声明指定的字段来轻松改变这个端口，甚至可以通过在项目依赖中加入spring-boot-starter-jetty或spring-boot-starter-undertow来改变Web容器。

常见的Starter（启动器）
===============================
关于Starter，它们的官方命名模式是 ``spring-boot-starter-*``，其中 ``*`` 是特定类型的Starter。在Spring Boot中，有很多可用的Starter，但我想给大家简单介绍一下其中最流行的启动器，这些启动器也被用于本书以下章节提供的示例中。

* spring-boot-starter：核心启动器，包括自动配置支持、日志和YAML。
* spring-boot-starter-web：允许我们构建Web应用程序，包括RESTful和Spring MVC。使用Tomcat作为默认的嵌入式容器。
* spring-boot-starter-jetty：在项目中包含Jetty，并将其设置为默认的嵌入式servlet容器。
* spring-boot-starter-undertow：在项目中包含undertow，并将其设置为默认的嵌入式servlet容器。
* spring-boot-starter-tomcat：包括Tomcat作为嵌入式servlet容器。Spring-boot-starter-web默认使用的servlet容器启动器。
* spring-boot-starter-actuator：在项目中包含Spring Boot Actuator，它提供了监控和管理应用程序的功能。
* spring-boot-starter-jdbc：包括Spring JBDC与Tomcat连接池。具体数据库的驱动需要自己提供。
* spring-boot-starter-data-jpa：包括使用JPA/Hibernate与关系型数据库交互所需的所有构件。
* spring-boot-starter-data-mongodb：包括与MongoDB交互以及在本地主机上初始化客户端与Mongo的连接所需的所有构件。
* spring-boot-starter-security：在项目中包含Spring Security，并默认启用应用程序的基本安全。
* spring-boot-starter-test：允许使用JUnit、Hamcrest和Mockito等库创建单元测试。
* spring-boot-starter-amqp：将Spring AMQP包含到项目中，并启动RabbitMQ作为默认的AMQP代理。

@SpringBootApplication
===========================
@SpringBootApplication 是一个复合 Annotation，通过其源码，看到看到是由下面3个Annotation组成的复合 Annotation：

* @Configuration
* @EnableAutoConfiguration
* @ComponentScan

每次都写3个 Annotation 显然过于繁琐，所以写一个 @SpringBootApplication 这样的一站式复合 Annotation 显然更方便些。因此DemoApplication类中等同于下面的写法：

.. code-block:: java
    :linenos:

    @Configuration
    @EnableAutoConfiguration
    @ComponentScanpublic
    class DemoApplication {
        public static void main(String[] args) {
            SpringApplication.run(DemoApplication.class, args);
        }
    }

@Configuration
=====================
 @Configuration 对我们来说并不陌生，它就是 JavaConfig 形式的 Spring IoC 容器的配置类使用的那个 @Configuration，既然 SpringBoot 应用骨子里就是一个 Spring 应用，那么，自然也需要加载某个 IoC 容器的配置，而 SpringBoot 社区推荐使用基于 JavaConfig 的配置形式，所以，很明显，这里的启动类标注了 @Configuration 之后，本身其实也是一个 IoC 容器的配置类！

@EnableAutoConfiguration
==============================
@EnableAutoConfiguration 其实也没啥“创意”，各位是否还记得 Spring 框架提供的各种名字为 @Enable 开头的 Annotation 定义？

比如 @EnableScheduling、@EnableCaching、@EnableMBeanExport 等，@EnableAutoConfiguration 的理念和“做事方式”其实一脉相承，简单概括一下就是，借助 @Import 的支持，收集和注册特定场景相关的 bean 定义：

* @EnableScheduling 是通过 @Import 将 Spring 调度框架相关的 bean 定义都加载到 IoC 容器。
* @EnableMBeanExport 是通过 @Import 将 JMX 相关的 bean 定义加载到 IoC 容器。

而 @EnableAutoConfiguration 也是借助 @Import 的帮助，将所有符合自动配置条件的 bean 定义加载到 IoC 容器，仅此而已！

@ComponentScan
===================
可有可无的@ComponentScan，为啥说 @ComponentScan 是可有可无的？

因为原则上来说，作为 Spring 框架里的“老一辈革命家”，@ComponentScan 的功能其实就是自动扫描并加载符合条件的组件或 bean 定义，最终将这些 bean 定义加载到容器中。加载 bean 定义到 Spring 的 IoC 容器，我们可以手工单个注册，不一定非要通过批量的自动扫描完成，所以说 @ComponentScan 是可有可无的。

SpringApplication.run执行流程详解
====================================

 .. image:: images/springbootflow.png
    :width: 600px

CommandLineRunner
************************

.. code-block:: java
    :linenos:

    public interface CommandLineRunner {
        void run(String... args) throws Exception;
    }

    package com.example.demo;

    import org.springframework.boot.CommandLineRunner;
    import org.springframework.boot.SpringApplication;
    import org.springframework.boot.autoconfigure.SpringBootApplication;
    import org.springframework.web.bind.annotation.RequestMapping;
    import org.springframework.web.bind.annotation.RestController;

    @RestController
    @SpringBootApplication
    public class DemoApplication implements CommandLineRunner {

        @RequestMapping("/")
        String home() {
            return "Hello World!";
        }

        public static void main(String[] args) {
            SpringApplication.run(DemoApplication.class, args);
        }

        @Override
        public void run(String... args) throws Exception {

            for (String arg : args) {
                System.out.println(arg);
            }
        }

    }


spring-boot-maven-plugin
=============================================
一旦我们声明了主类并包含了spring-boot-starter-web，我们只需要运行我们的第一个应用程序。如果你使用一个开发IDE，比如Eclipse或IntelliJ，你应该只运行你的main类。否则，应用程序必须像一个标准的Java应用程序一样使用java -jar命令来构建和运行。首先，我们应该提供配置，负责在应用程序构建过程中把所有的依赖关系打包成一个可执行的JAR。Maven的pom.xml中定义了spring-boot-maven-plugin，那么这个操作将由spring-boot-maven-plugin来执行。

.. code-block:: xml
    :linenos:

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>

这个示例应用程序只不过是在Tomcat容器上启动了一个Spring上下文，这个容器的端口是8080。这个JAR大约有14MB大小。可以很容易地使用IDE检查出项目中包含了哪些库。这些都是基本的Spring库，如spring-core、spring-aop、spring-context；Spring Boot；Tomcat embedded；用于日志记录的库，包括Logback、Log4j和Slf4j；以及用于JSON序列化或反序列化的Jackson库。一个好主意是为项目设置默认的Java版本。可以在pom.xml中通过声明java.version属性轻松设置。

.. code-block:: xml
    :linenos:

    <properties>
       <java.version>1.8</java.version>
    </properties>




Spring Container
=============================================
我们可以通过添加一个新的依赖关系来改变默认的web容器，例如，Jetty服务器：

.. code-block:: xml
    :linenos:

    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-jetty</artifactId>
    </dependency>




自定义配置文件
=============================================

拥有快速创建应用程序的能力是一回事，不需要大量的工作，但同样重要的是能够轻松定制和覆盖默认设置。Spring Boot提供了实现配置管理的机制。最简单的方法是使用配置文件，它被附加到应用程序的JAR中。Spring Boot会自动检测名称以应用程序前缀开头的配置文件。支持的文件类型是 ``.properties`` 和 ``.yml`` 。因此，我们可以创建配置文件，如
作为application.properties或application.yml，甚至包括配置文件专用文件，如application-prod.properties或application-dev.yml。此外，我们还可以使用
OS环境变量和命令行参数来外部化配置。当使用属性或YAML文件时，它们应该被放置在以下位置之一：

* 当前应用程序目录的/config子目录 
* 当前应用程序目录
* 一个classpath /config包（例如，在你的JAR里面） 
* classpath根目录

如果你想给你的配置文件起一个特定的名字，而不是application或application-{profile}，你需要在启动时提供一个spring.config.name环境属性。你也可以使用 spring.config.location 属性，它包含一个以逗号分隔的目录位置或文件路径列表。

.. code-block:: sh
    :linenos:

    java -jar sample-spring-boot-web.jar --spring.config.name=example
    java -jar sample-spring-boot-web.jar --spring.config.location=classpath:/example.propert



@ConfigurationProperties
=============================================
在配置文件里面，我们可以定义两类属性。首先，有一组通用的、预定义的Spring Boot属性，这些属性被底层类所消耗，大多来自spring-boot-autoconfigure库。我们也可以定义自己的自定义配置属性，然后使用@Value或@ConfigurationProperties注释将其注入到应用程序中。

通常情况下，application.yml文件放在src/main/resources目录下，Maven构建完成后，该目录就位于JAR根目录下。下面是一个示例配置文件，它可以覆盖默认的服务器端口、应用程序名称和日志属性。

.. code-block:: yaml
    :linenos:

    server:
        port: ${port:2222}
    spring:
        application:
            name: first-service
    logging:
        pattern:
            console: "%d{HH:mm:ss.SSS} %-5level %logger{36} - %msg%n"
            file: "%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n"
        level:
            org.springframework.web: DEBUG
        file: app.log


这里不需要定义任何其他外部配置文件，比如log4j.xml或者logback.xml来进行日志配置。在前面的片段中，你可以看到我把org.springframework.web的默认日志级别改成了DEBUG和日志模式，并创建了一个日志文件app.log，放在了当前应用目录下。现在，默认的应用程序名称是first-service，默认的HTTP端口是2222。

我们的自定义配置设置也应该放在同样的属性或YAML文件中。下面是一个带有自定义属性的示例application.yml。

.. code-block:: yaml
    :linenos:

    name: first-service
    my:
        servers:
        - dev.bar.com
        - foo.bar.com


可以使用@Value注解注入一个简单的属性。

.. code-block:: java
    :linenos:

    @Component
    public class CustomBean {
        @Value("${name}")
        private String name;
        // ... 
    }


还可以使用以下方法注入更复杂的配置属性的@ConfigurationProperties注解。在YAML文件中的my.servers属性中定义的值列表被注入到目标Bean中，其类型为java.util.List。

.. code-block:: java
    :linenos:

    @ConfigurationProperties(prefix="my")
    public class Config {
        private List<String> servers = new ArrayList<String>();
        
        public List<String> getServers() {
            return this.servers;
        } 
    }


到目前为止，我们已经成功创建了一个简单的应用程序，它所做的只是在Tomcat或Jetty等Web容器上启动Spring。在本章的这一部分，我想向你展示使用Spring Boot启动应用程序开发是多么简单。除此之外，我还介绍了如何使用YAML或属性文件来定制配置。对于那些喜欢点击而不是打字的人，我推荐你使用Spring Initializr网站(https://start.spring.io/)，您可以根据您选择的选项生成项目存根。在简单的网站视图中，您可以选择构建工具（Maven/Gradle）、语言（Java/Kotlin/Groovy）和Spring Boot版本。然后，你应该使用下面的搜索引擎提供所有必要的依赖关系。
Search for dependencies标签。spring-boot-starter-web在Spring Initializr上只是被标注为Web。点击生成项目后，包含生成的源代码的ZIP文件会被下载到你的电脑上。您可能还有兴趣知道，通过点击切换到完整版，您能够看到几乎所有可用的Spring Boot和Spring Cloud库，这些库可以包含在生成的项目中。
