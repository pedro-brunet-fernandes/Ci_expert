Projeto hello.tcl

Este projeto apresenta um exemplo simples em TCL para mostrar conceitos básicos da linguagem. O script imprime mensagens na tela, demonstra o uso do comando puts, cria variáveis escalares, exibe seus valores e também mostra como acessar variáveis por referência com upvar.

No início, o programa imprime "Hello world" e "!!!", incluindo um exemplo com puts -nonewline, que escreve na mesma linha sem quebrar linha automaticamente. Em seguida, cria uma variável numérica (a), uma variável de texto (str) e uma variável com nome composto (Pedro Henrique), exibindo seus respectivos conteúdos. Por fim, usa upvar para associar a variável b à variável a, mostrando como funciona a referência entre variáveis em TCL.

Para executar, é necessário ter o interpretador TCL instalado no sistema. Salve o código em um arquivo chamado hello.tcl, dê permissão de execução com:

chmod +x hello.tcl

e depois execute com:

./hello.tcl
