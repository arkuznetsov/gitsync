﻿///////////////////////////////////////////////////////////////////
//
// Служебный модуль с реализацией работы команды sync
//
// Представляет собой модификацию приложения gitsync от 
// команды oscript-library
//
// Структура модуля реализована в соответствии с рекомендациями 
// oscript-app-template (C) EvilBeaver
//
///////////////////////////////////////////////////////////////////

Перем Лог;

Процедура ЗарегистрироватьКоманду(Знач ИмяКоманды, Знач Парсер) Экспорт

	ОписаниеКоманды = Парсер.ОписаниеКоманды(ИмяКоманды, "Выполняет синхронизацию хранилища 1С с git-репозиторием (указание имени команды необязательно)");
	
	Парсер.ДобавитьПозиционныйПараметрКоманды(ОписаниеКоманды, "ПутьКХранилищу", "Файловый путь к каталогу хранилища конфигурации 1С.");
	Парсер.ДобавитьПозиционныйПараметрКоманды(ОписаниеКоманды, "URLРепозитория", "Адрес удаленного репозитория GIT.");
	Парсер.ДобавитьПозиционныйПараметрКоманды(ОписаниеКоманды, "ЛокальныйКаталогГит", "Каталог исходников внутри локальной копии git-репозитария.");

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "-email", "<домен почты для пользователей git>");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "-v8version", "<Маска версии платформы (8.3, 8.3.5, 8.3.6.2299 и т.п.)>");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "-debug", "<on|off>");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "-verbose", "<on|off>");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "-branch", "<имя ветки git>");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "-format", "<hierarchical|plain>");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "-tempdir", "<Путь к каталогу временных файлов>");
	
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "-amount-look-for-license", "<число> количество повторов получения лицензии (попытка подключения каждые 10 сек), 0 - без ограничений");

	Парсер.ДобавитьИменованныйПараметрКоллекцияКоманды(ОписаниеКоманды, "-plugins", "Плагины к загрузке и исполнения");	

	Парсер.ДобавитьКоманду(ОписаниеКоманды);

	// для использования по умолчанию
	Парсер.ДобавитьПараметр("ПутьКХранилищу", "Файловый путь к каталогу хранилища конфигурации 1С.");
	Парсер.ДобавитьПараметр("URLРепозитория", "Адрес удаленного репозитория GIT.");
	Парсер.ДобавитьПараметр("ЛокальныйКаталогГит", "Каталог исходников внутри локальной копии git-репозитария.");

	Парсер.ДобавитьИменованныйПараметр("-email", "<домен почты для пользователей git>");
	Парсер.ДобавитьИменованныйПараметр("-v8version", "<Маска версии платформы (8.3, 8.3.5, 8.3.6.2299 и т.п.)>");
	Парсер.ДобавитьИменованныйПараметр("-debug", "<on|off>");
	Парсер.ДобавитьИменованныйПараметр("-verbose", "<on|off>");
	Парсер.ДобавитьИменованныйПараметр("-branch", "<имя ветки git>");
	Парсер.ДобавитьИменованныйПараметр("-format", "<hierarchical|plain>");
	Парсер.ДобавитьИменованныйПараметр("-tempdir", "<Путь к каталогу временных файлов>");

КонецПроцедуры // ЗарегистрироватьКоманду

Функция ВыполнитьКоманду(Знач ПараметрыКоманды, Знач ДополнительныеПараметры) Экспорт

	Лог = ДополнительныеПараметры.Лог;
	Лог.Информация("Начинаю синхронизацию хранилища 1С и репозитария GIT");

	ПутьКХранилищу			= ПараметрыКоманды["ПутьКХранилищу"];
	URLРепозитория			= ПараметрыКоманды["URLРепозитория"];
	ЛокальныйКаталогГит		= ПараметрыКоманды["ЛокальныйКаталогГит"];
	ДоменПочты				= ПараметрыКоманды["-email"];
	ВерсияПлатформы			= ПараметрыКоманды["-v8version"];
	Формат					= ПараметрыКоманды["-format"];
	ИмяВетки				= ПараметрыКоманды["-branch"];

	СписокПлагинов = ПараметрыКоманды["-plugins"];
		
	ДополнительныеПараметры.Плагины.ПриВыполненииКоманды(ПараметрыКоманды, ДополнительныеПараметры);
	ДополнительныеПараметры.Вставить("СписокПлагинов", СписокПлагинов);

		
	Если ЛокальныйКаталогГит = Неопределено Тогда

		ЛокальныйКаталогГит = ТекущийКаталог();

	КонецЕсли;

	Если Формат = Неопределено Тогда

		Формат = РежимВыгрузкиФайлов.Авто;

	КонецЕсли;

	Если ИмяВетки = Неопределено Тогда

		ИмяВетки = "master";

	КонецЕсли;


	Лог.Отладка("ПутьКХранилищу = " + ПутьКХранилищу);
	Лог.Отладка("URLРепозитория = " + URLРепозитория);
	Лог.Отладка("ЛокальныйКаталогГит = " + ЛокальныйКаталогГит);
	Лог.Отладка("ДоменПочты = " + ДоменПочты);
	Лог.Отладка("ВерсияПлатформы = " + ВерсияПлатформы);
	Лог.Отладка("Формат = " + Формат);
	Лог.Отладка("ИмяВетки = " + ИмяВетки);
	
	Распаковщик = РаспаковщикКонфигурации.ПолучитьРаспаковщик(ДополнительныеПараметры);
	Распаковщик.ВерсияПлатформы = ВерсияПлатформы;
	Распаковщик.ДоменПочтыДляGitПоУмолчанию = ДоменПочты;
	
	Лог.Информация("Синхронизация изменений с хранилищем");
	РаспаковщикКонфигурации.ВыполнитьЭкспортИсходников(Распаковщик, 
							ПутьКХранилищу, 
							ЛокальныйКаталогГит, 
							, 
							, 
							Формат, 
							, 
							URLРепозитория,
							,
							,
							ИмяВетки,
							,
							,
							);

	Лог.Информация("Синхронизация завершена");
	
	Возврат МенеджерКомандПриложения.РезультатыКоманд().Успех;

КонецФункции // ВыполнитьКоманду