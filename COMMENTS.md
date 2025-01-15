Desafio Devops

PIPELINE CI/CD

Foi criado uma pipeline onde temos o ci e o cd da aplicação, essa pipeline esta configurada pra questões de testes, para ser disparada de forma manual, mas com a evolução do projeto ela irá disparar a partir de determinadas branchs, onde cada branch irá realizar um deploy em um ambiente diferente (exemplo dev, hml e prd).

Para as etapas de ci, com a evolução do projeto também será adicionado etapas de qualidade de código com sonarqube, uma etapa de verificação de segurança com trivy tanto para checar vulnerábilidades em bibliotecas do app como do container em si e para a etapa de cd ainda será utilizado o kustomize para configuração de cada ambiente.

Conforme evolução do projeto e maturidade da equipe e da aplicação, uma alternativa será substituir a etapa de deploy para um gitops, utilizando como exemplo a ferramenta argocd, assim ao invés de aplicarmos os manifestos k8s na pipeline, faríamos apenas o sed na tag "imagem" do deployment e os comendos de commit e push do github para que o argocd se encarregue de realizar o update do pod, assim teríamos rollbacks mais ágeis e garantiremos que o deploy seja fiel ao que esta no código.

Outra evolução ainda falando da pipeline, seria a promoção de imagem, ao invés de realizarmos os builds em todas as branchs que apontam para um ambiente, onde considerando o cenário que teremos feat entregando em dev, develop entregando em hml e main entregando em prd, a branch feat seria a unica a ter a etapa de build e as demais branchs apenas fariam um retag, assim ainda garantiriamos que a imagem que foi desenvolvida na feat e homologada em hml, seria a mesma que iria para produção.


INFRAESTRUTURA

Foi desenvolvido um código terraform simples e uma pipeline para realizar o provisionamento do mesmo. A pipeline esta configurada em um formato para teste, mas para ambientes reais seria ideial criar uma trava onde tivessemos um controle por usuários com privilégios que permitissem o apply, etapas de teste para garantir a qualidade do código e poderíamos criar alguns módulos personalizados onde seria disponibilizado ao usuário a opção via parametros de subir o cluster conforme necessidade, assim teríamos a possibilidade de subir clusters para cada ambiente de acordo com suas particularidades.

No terraform em si, temos o provisionamento apenas de um eks, seus nodes, vpc e subnets, também foram criadas subnets públicas e privadas, porque a idéia é disponibilizar um mongodb que trataria de armazenar as mensagens enviadas na aplicação e a comunicação poderia ser feita via rede privada, já a publica nos possibilita de disponibilizar a aplicação para todos.


APLICAÇÃO E KUBERNETES

Em relação a infraestrutura para a aplicação, termos que evoluir com o uso de um serviço de mensageria como Rabbitmq ou Kafka para suprir o aumento de usuários na aplicação e caso o hpa do kubernetes não seja o suficiente podemos evoluir também para uso do keda e assim seria possível escalar a aplicação conforme demanda no serviço de mensageria.

Alguns serviços que não foram adicionados no k8s, conforme crescimento da aplicação, também seriam necessários, como hpa, ingress, secrets e configmaps


MONITORAMENTO

Para o monitoramento, será utilizado prometheus para a monitoração da aplicação, grafana para os dashboards, loki para disponibilização dos logs e o alertmanager para notificação de alertas e para facilitar a gestão deles e configuração, utilizariamos os operators dentro da própria stack do kubernetes.


OBSERVAÇÕES FINAIS

Infelizmente não houve tempo habil para realizar todas as ideias e nem organizar todo o projeto para exemplificar melhor as ideias aqui mencionadas, principalmente a gestão de ambientes com as ferramentas e pipelines.