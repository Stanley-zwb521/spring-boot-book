###################################
Spring Boot 和 RESTful 服务
###################################

第一步，让我们创建RESTful Web服务，将一些数据暴露给调用客户端。如前所述，负责JSON消息序列化和反序列化的Jackson库与spring-boot-starter-web 一起自动包含在我们的classpath中。多亏了这一点，我们除了声明一个模型类之外，不需要做更多的事情，然后这个模型类就会被REST方法返回或作为参数。下面是我们的示例模型类，Person：

.. code-block:: java
    :linenos:

    public class Person {
        private Long id;
        private String firstName;
        private String lastName;
        private int age;
        public Long getId() {
            return id;
        }
        public void setId(Long id) {
            this.id = id;
        }
        //... 
    }


Spring Web为创建RESTful Web服务提供了一些注解。其中第一个是@RestController注解，它应该设置在你的controller bean类上，它负责处理传入的HTTP请求。还有一个是@RequestMapping注解，它通常用于将控制器方法映射到HTTP。正如你在下面的代码片段中所看到的，它可以用于整个controller类，为它里面的所有方法设置请求路径。我们可以对具体的HTTP方法使用更具体的注解，比如@GetMapping或者@PostMapping。
@GetMapping和@RequestMapping一样，参数method=RequestMethod.GET。另外两个常用的注解是@RequestParam和@RequestBody。第一个注释将路径和查询参数绑定到对象上；第二个注释使用Jackson库将输入的JSON映射到对象上。

.. code-block:: java
    :linenos:
        
    @RestController
    @RequestMapping("/person")
    public class PersonController {
        private List<Person> persons = new ArrayList<>();
        @GetMapping
        public List<Person> findAll() {
            return persons;
        }
    
        @GetMapping("/{id}")
        public Person findById(@RequestParam("id") Long id) {
            return persons.stream().filter(it -> it.getId().equals(id)).findFirst().get();
        }

        @PostMapping
        public Person add(@RequestBody Person p) {
            p.setId((long) (persons.size()+1));
            persons.add(p);
            return p;
        }
        // ... 
    }

为了兼容REST API标准，我们应该处理PUT和DELETE方法。在实现它们之后，我们的服务会执行所有的CRUD操作。

* GET   /person 返回所有的persons
* GET   /person/{id}  返回指定id的person
* POST  /person 添加person
* PUT   /person 更新person
* DELETE    /person/{id}    删除指定id的person

这里是一个带有DELETE和PUT方法的@RestController实现的示例片段。

.. code-block:: java
    :linenos:

	@DeleteMapping("/{id}")
	public void delete(@RequestParam("id") Long id) {
		List<Person> p = persons.stream().filter(it -> it.getId().equals(id)).collect(Collectors.toList());
		persons.removeAll(p);
	}

	@PutMapping
	public void update(@RequestBody Person p) {
		Person person = persons.stream().filter(it -> it.getId().equals(p.getId())).findFirst().get();
		persons.set(persons.indexOf(person), p);
	}


API文档
=============



使用OpenAPI 3.0编写Spring REST API文档
****************************************************************
文档是构建REST API的重要组成部分。在本教程中，我们将了解SpringDoc--一个基于OpenAPI 3规范，简化API文档生成和维护的工具。

设置springdoc-openapi
****************************************************************
要让springdoc-openapi自动为我们的API生成OpenAPI 3规范文档，我们只需在pom.xml中添加springdoc-openapi-ui依赖关系。

.. code-block:: xml
    :linenos:

    <dependency>
        <groupId>org.springdoc</groupId>
        <artifactId>springdoc-openapi-ui</artifactId>
        <version>1.2.32</version>
    </dependency>

然后，当我们运行我们的应用程序时，OpenAPI描述将默认在路径/v3/api-docs中，例如：http://localhost:8080/v3/api-docs/

要使用自定义路径，我们可以在application.properties文件中注明::

    springdoc.api-docs.path=/api-docs

现在，我们就可以在这里访问文档了：http://localhost:8080/api-docs/

OpenAPI的定义默认为JSON格式。对于yaml格式，我们可以在以下地方获得定义：http://localhost:8080/v3/api-docs.yaml


使用Swagger UI设置springdoc-openapi
========================================
除了本身生成OpenAPI 3规范外，我们还可以将springdoc-openapi与Swagger UI集成，这样就可以与我们的API规范进行UI交互。

Swagger是设计、构建和记录RESTful API的最流行工具。它是由SmartBear创建的，SmartBear是一个非常流行的SOAP Web服务工具SoapUI的设计者。我想，对于那些长期使用SOAP的人来说，这可能是足够的推荐。总之，使用Swagger，我们可以使用notation（符号）设计API，然后从中生成源码，或者反过来，我们从源码开始，然后生成一个Swagger文件。对于Spring Boot，我们使用第二种选择。

我们要做的就是在项目的pom.xml中添加springdoc-openapi-ui的依赖关系，来设置springdoc-openapi和Swagger UI。上面添加的springdoc-openapi-ui就已经包含了Swagger的全部依赖。我们现在可以通过以下网址访问API文档。

    http://localhost:8080/swagger-ui.html

支持swagger-ui属性
**********************
Springdoc-openapi 还支持 swagger-ui 属性。这些属性可以作为Spring Boot属性使用，前缀为springdoc.swagger-ui。

例如，让我们自定义API文档的路径。我们可以通过修改我们的application.properties来做到这一点::

    springdoc.swagger-ui.path=/swagger-ui-custom.html

所以现在我们的API文档变更为：http://localhost:8080/swagger-ui-custom.html。


参考
=========
#. https://www.baeldung.com/spring-rest-openapi-documentation
#. https://www.baeldung.com/rest-with-spring-series