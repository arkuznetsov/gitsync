﻿#Использовать configor

Перем Лог;

Процедура ОписаниеКоманды(Команда) Экспорт
	
	Команда.Опция("t timer", 0, "таймер повторения синхронизации, сек")
					.ТЧисло()
					.ВОкружении("GITSYNC_ALL_TIMER");

	Команда.Опция("thread", 1, "количество потоков выполнения")
					.ТЧисло()
					.ВОкружении("GITSYNC_ALL_THREAD");

	Команда.Опция("n name", "", "имя настройки пакетной синхронизации")
					.ТСтрока();
	
	Команда.Опция("u storage-user", "", "пользователь хранилища конфигурации")
					.ТСтрока()
					.ВОкружении("GITSYNC_STORAGE_USER");

	Команда.Опция("p storage-pwd", "", "пароль пользователя хранилища конфигурации")
					.ТСтрока()
					.ВОкружении("GITSYNC_STORAGE_PASSWORD GITSYNC_STORAGE_PWD");
	
	Команда.Аргумент("CONFIG", "", "путь к файлу настройки пакетной синхронизации")
					.ТСтрока()
					.ВОкружении("GITSYNC_ALL_CONFIG")
					.Обязательный(Ложь)
					.ПоУмолчанию(ОбъединитьПути(ТекущийКаталог(), ПараметрыПриложения.ИмяФайлаНастройкиПакетнойСинхронизации()));

	ПараметрыПриложения.ВыполнитьПодпискуПриРегистрацииКомандыПриложения(Команда);
	
КонецПроцедуры

Процедура ВыполнитьКоманду(Знач Команда) Экспорт

	Лог.Информация("Начало выполнение команды <all>");
	
	ПутьКФайлуНастроек			= Команда.ЗначениеАргумента("CONFIG");
	
	ПользовательХранилища		= Команда.ЗначениеОпции("storage-user");
	ПарольПользователяХранилища	= Команда.ЗначениеОпции("storage-pwd");
	
	ИмяНастройкиСинхронизации	= Команда.ЗначениеОпции("name");
	КоличествоПотоковСинхронизации	= Команда.ЗначениеОпции("thread");
	
	ИнтервалПовторенияСинхронизации = Команда.ЗначениеОпции("timer");

	ПользовательИБ			= Команда.ЗначениеОпции("ib-user");
	ПарольПользователяИБ	= Команда.ЗначениеОпции("ib-pwd");
	СтрокаСоединенияИБ		= Команда.ЗначениеОпции("ib-connection");
	
	ФайлНастроек = Новый Файл(ПутьКФайлуНастроек);
	Если Не ФайлНастроек.Существует() Тогда
		ВызватьИсключение СтрШаблон("Файл настроек <%1> не найден", ФайлНастроек.ПолноеИмя);
	КонецЕсли;

	ОбщиеПараметры = ПараметрыПриложения.Параметры();

	ПараметрыФайлаНастроек = ПрочитатьФайлНастроек(ПутьКФайлуНастроек);

	Если ПараметрыФайлаНастроек.Количество() = 0 Тогда
		ВызватьИсключение "Файл настроек не содержит данных";
	КонецЕсли;

	ПакетнаяСинхронизация = Новый ПакетнаяСинхронизация();
	ПакетнаяСинхронизация
				.ТаймерПовторения(ИнтервалПовторенияСинхронизации)
				.КаталогПлагинов(ПараметрыПриложения.КаталогПлагинов())
				.ВерсияПлатформы(ОбщиеПараметры.ВерсияПлатформы)
				.ДоменПочтыПоУмолчанию(ОбщиеПараметры.ДоменПочты)
				.ИсполняемыйФайлГит(ОбщиеПараметры.ПутьКГит)
				.ПутьКПлатформе(ОбщиеПараметры.ПутьКПлатформе)
			   	.РежимУдаленияВременныхФайлов(Истина)
				.АвторизацияВХранилищеКонфигурации(ПользовательХранилища, ПарольПользователяХранилища)
				;
	
	ПакетнаяСинхронизация.ПрочитатьНастройки(ПараметрыФайлаНастроек);	

	Если ЗначениеЗаполнено(ИмяНастройкиСинхронизации) Тогда
		ПакетнаяСинхронизация.ВыполнитьСинхронизациюПоНастройке(ИмяНастройкиСинхронизации,
																СтрокаСоединенияИБ,
																ПользовательИБ, 
																ПарольПользователяИБ);
	Иначе
		ПакетнаяСинхронизация.ВыполнитьСинхронизацию(КоличествоПотоковСинхронизации,
														СтрокаСоединенияИБ,
														ПользовательИБ,
														ПарольПользователяИБ);
	КонецЕсли;
	
	Лог.Информация("Завершено выполнение команды <all>");
		
КонецПроцедуры

Функция ПрочитатьФайлНастроек(Знач ПутьКФайлуНастроек)

	Лог.Отладка("Чтение файла настроек начато");
	
	ТекстФайла = РаботаСФайлами.ПрочитатьФайл(ПутьКФайлуНастроек);

	Лог.Отладка("Чтение файла настроек завершено");

	ПрочитанныйПараметры = РаботаСФайлами.ОбъектИзJson(ТекстФайла);

	ЭтоОдинРепозиторий = ПрочитанныйПараметры.Получить("repositories") = Неопределено
							И ПрочитанныйПараметры.Получить("Репозитории") = Неопределено;
	
	Параметры = ПрочитанныйПараметры;

	Если ЭтоОдинРепозиторий Тогда
		
		Параметры = Новый Соответствие(); 
		МассивРепозиториев = Новый Массив;
		МассивРепозиториев.Добавить(ПрочитанныйПараметры);

		Параметры.Вставить("repositories", МассивРепозиториев);

	КонецЕсли;

	Возврат Параметры;

КонецФункции


Лог = ПараметрыПриложения.Лог();