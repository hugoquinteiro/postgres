@echo off
title DUMP no PostgreSQL - WebSac
color 2
rem Exportando as variaveis para que nao seja necessario a interacao do usuario
rem IP do servidor PostgreSQL
set PGHOST=localhost
rem Caminho para o executável do pg_dump
set PGBINDIR="C:\Program Files (x86)\pgAdmin III\1.18"
rem Porta de acesso ao PostgreSQL
set PGPORT=5432
rem Database que será feito backup
set PGDATABASE=websac
rem Usuário da base de dados
set PGUSER=postgres
rem Senha da base de dados
set PGPASSWORD=postgres
rem Diretório de destino do arquivo de dump
set DESTDIR=C:\Backup

rem Observa‡Æo: Caso queira colocar o nome do backup seguindo de uma data ‚ s¢ usar:
for /f "tokens=1,2,3,4 delims=/ " %%a in ('DATE /T') do set Date=%%a-%%b-%%c
rem O comando acima serve para armazenar a data no formato dia-mes-ano na vari vel Date;

rem Comando para gerar o DUMP da base de dados
%PGBINDIR%\pg_dump.exe -F c -b -v -f %destdir%\Backup%Date%.backup
rem Exit

