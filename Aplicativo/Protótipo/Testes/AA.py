import tkinter as tk
from tkinter import ttk

class AplicativoCadastro:
    def __init__(self, janela):
        self.janela = janela
        self.janela.title("Projeto_AA")

        self.notebook = ttk.Notebook(janela)
        self.notebook.pack()

        self.tab_cadastro = ttk.Frame(self.notebook)
        self.notebook.add(self.tab_cadastro, text="Cadastro")

        self.tab_visualizacao = ttk.Frame(self.notebook)
        self.notebook.add(self.tab_visualizacao, text="Visualização")

        self.tab_teste = ttk.Frame(self.notebook)
        self.notebook.add(self.tab_teste, text="Teste")

        # Campos de entrada no tab de Cadastro
        self.frame_cadastro = ttk.Frame(self.tab_cadastro, padding=20)
        self.frame_cadastro.pack()

        self.label_op = ttk.Label(self.frame_cadastro, text="Op:")
        self.label_op.grid(row=0, column=0, sticky="e")
        self.input_op = ttk.Entry(self.frame_cadastro)
        self.input_op.grid(row=0, column=1)

        self.label_quant = ttk.Label(self.frame_cadastro, text="Quantidade:")
        self.label_quant.grid(row=1, column=0, sticky="e")
        self.input_quant = ttk.Entry(self.frame_cadastro)
        self.input_quant.grid(row=1, column=1)

        self.botao_cadastrar = ttk.Button(self.frame_cadastro, text="Cadastrar", command=self.cadastrar)
        self.botao_cadastrar.grid(row=3, columnspan=2, pady=10)

        # Exibição das informações no tab de Visualização
        self.frame_visualizacao = ttk.Frame(self.tab_visualizacao, padding=20)
        self.frame_visualizacao.pack()

        self.label_visualizacao = ttk.Label(self.frame_visualizacao, text="Informações cadastradas:")
        self.label_visualizacao.pack()

        self.texto_visualizacao = tk.Text(self.frame_visualizacao, width=40, height=10)
        self.texto_visualizacao.pack()

        # Botão de teste no tab de Teste
        self.frame_teste = ttk.Frame(self.tab_teste, padding=20)
        self.frame_teste.pack()

        self.botao_teste = ttk.Button(self.frame_teste, text="Teste", command=self.exibir_teste)
        self.botao_teste.pack(pady=10)

        # Campo de resultados no tab de Teste
        self.resultados = tk.Label(self.frame_teste, text="Resultados aparecem aqui")
        self.resultados.pack()

    def cadastrar(self):
        ordem = self.input_op.get()
        quantidade = self.input_quant.get()

        informacoes = f"Op: {ordem}\nQuantidade: {quantidade}\n\n"
        self.texto_visualizacao.insert(tk.END, informacoes)

        self.limpar_campos()

    def exibir_teste(self):
        self.resultados.config(text="Resultados apenas no projeto final")

    def limpar_campos(self):
        self.input_op.delete(0, tk.END)
        self.input_quant.delete(0, tk.END)


janela = tk.Tk()
aplicativo = AplicativoCadastro(janela)
janela.mainloop()