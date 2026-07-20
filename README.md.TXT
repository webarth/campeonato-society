# Campeonato Society — Deploy (Supabase + Vercel)

## 1. Criar o projeto no Supabase
1. Acesse supabase.com → **New project**. Anote a senha do banco (não precisa mais dela depois).
2. Vá em **SQL Editor** → cole todo o conteúdo do arquivo `schema.sql` deste projeto → **Run**.
   Isso cria as tabelas (times, atletas, jogos, eventos, organizadores, configuração) e libera o acesso via chave pública.
3. Vá em **Storage** → **New bucket** → nome exatamente `player-photos` → marque **Public bucket** → Create.
   (é onde ficam as fotos dos atletas)
4. Vá em **Settings → API**. Copie:
   - **Project URL**
   - **anon public key**

## 2. Configurar o site
Abra o arquivo `index.html` e substitua no topo do `<script>`:

```js
const SUPABASE_URL = "COLE_AQUI_A_URL_DO_SEU_PROJETO_SUPABASE";
const SUPABASE_ANON_KEY = "COLE_AQUI_A_ANON_PUBLIC_KEY";
```
pelos valores copiados no passo anterior. Salve o arquivo.

## 3. Colocar no GitHub
Crie um repositório novo (pode ser privado) e suba estes dois arquivos (`index.html` e `schema.sql`):

```bash
git init
git add index.html schema.sql README.md
git commit -m "Campeonato society - versão inicial"
git branch -M main
git remote add origin https://github.com/SEU_USUARIO/SEU_REPOSITORIO.git
git push -u origin main
```

## 4. Publicar no Vercel
1. Acesse vercel.com → **Add New → Project** → importe o repositório do GitHub.
2. Em **Framework Preset**, deixe como **Other** (é um site estático, sem build).
3. Não precisa configurar Build Command nem Output Directory — clique em **Deploy**.
4. Em alguns segundos o Vercel te dá uma URL pública (ex: `seucampeonato.vercel.app`). É esse link que você compartilha com organizadores e responsáveis de time.

## 5. Primeiro acesso
1. Abra o site publicado → escolha **Proprietário** → código padrão `owner2027`.
2. Vá em **Configurações** e troque esse código imediatamente.
3. Vá em **Organizadores** e crie a primeira conta de organizador (usuário + senha).
4. Saia, entre como **Organizador** com essa conta, e comece a cadastrar times e atletas.

## Sobre segurança (leia antes de divulgar o link)
Este sistema usa a chave pública (`anon key`) do Supabase, que fica visível no código-fonte do site — é assim que qualquer app estático que fala direto com o Supabase funciona. As políticas de acesso ao banco (RLS) neste `schema.sql` estão **abertas**: o controle de quem pode editar o quê é feito pela interface (login de proprietário/organizador/responsável), não pelo banco em si. Isso é adequado para um campeonato amador entre pessoas de confiança, mas não é adequado se algum dia os dados forem sensíveis ou o sistema crescer para algo mais público — nesse caso, o próximo passo seria migrar para autenticação real do Supabase (Supabase Auth) com políticas de RLS por usuário.

## Atualizações futuras
Sempre que você (ou eu) alterar o `index.html`, basta:
```bash
git add index.html
git commit -m "descrição da mudança"
git push
```
O Vercel publica a nova versão automaticamente em poucos segundos.
