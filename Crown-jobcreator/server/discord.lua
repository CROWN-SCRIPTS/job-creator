DiscordLogger = {}

function DiscordLogger.SendLog(webhookUrl, title, description, color, fields, thumbnail)
    if not Config.Discord.enabled or not webhookUrl or webhookUrl == 'YOUR_CREATE_JOB_WEBHOOK_URL' then
        return
    end
    
    local embed = {
        {
            ["title"] = title,
            ["description"] = description,
            ["color"] = color,
            ["fields"] = fields,
            ["thumbnail"] = thumbnail and {["url"] = thumbnail} or nil,
            ["footer"] = {
                ["text"] = "Crown Job Creator System • " .. os.date("%d/%m/%Y at %H:%M:%S"),
                ["icon_url"] = Config.Discord.botAvatar
            },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }
    }
    
    local payload = {
        ["username"] = Config.Discord.botName,
        ["avatar_url"] = Config.Discord.botAvatar,
        ["embeds"] = embed
    }
    
    PerformHttpRequest(webhookUrl, function(err, text, headers) end, 'POST', json.encode(payload), { ['Content-Type'] = 'application/json' })
end

function DiscordLogger.GetMessages(locale)
    local messages = {
        ['da'] = {
            jobCreated = {
                title = "🆕 Nyt Job Oprettet",
                description = "Et nyt job er blevet oprettet i systemet",
                fields = {
                    jobInfo = "📋 Job Information",
                    administrator = "👤 Administrator", 
                    details = "📊 Detaljer",
                    status = "Status",
                    whitelisted = "Whitelist",
                    grades = "Ranger",
                    job = "Job",
                    label = "Label",
                    name = "Navn",
                    id = "ID",
                    discord = "Discord"
                }
            },
            jobDeleted = {
                title = "🗑️ Job Slettet",
                description = "Et job og alle dets ranger er blevet permanent slettet fra systemet",
                fields = {
                    deletedJob = "🗑️ Slettet Job",
                    administrator = "👤 Administrator",
                    impact = "⚠️ Påvirkning",
                    action = "Handling",
                    status = "Status",
                    grades = "Ranger",
                    players = "Spillere",
                    job = "Job",
                    name = "Navn",
                    id = "ID",
                    discord = "Discord"
                }
            },
            gradeCreated = {
                title = "⭐ Nyt Rang Oprettet",
                description = "En ny job rang er blevet oprettet",
                fields = {
                    gradeInfo = "⭐ Rang Information",
                    salaryDetails = "💰 Løn Detaljer",
                    administrator = "👤 Administrator",
                    job = "Job",
                    grade = "Rang",
                    label = "Label",
                    amount = "Beløb",
                    name = "Navn",
                    id = "ID",
                    discord = "Discord"
                }
            },
            protectedGradeUpdated = {
                title = "💰 Beskyttet Rang Opdateret",
                description = "Løn opdateret for beskyttet job rang - andre felter låst",
                fields = {
                    protectedJob = "🛡️ Beskyttet Job",
                    newSalary = "💰 Ny Løn",
                    administrator = "👤 Administrator",
                    job = "Job",
                    action = "Handling",
                    amount = "Beløb",
                    status = "Status",
                    name = "Navn",
                    id = "ID",
                    discord = "Discord"
                }
            },
            gradeUpdated = {
                title = "✏️ Rang Opdateret",
                description = "Et job rang er blevet opdateret",
                fields = {
                    gradeInfo = "✏️ Rang Information",
                    salaryDetails = "💰 Løn Detaljer",
                    administrator = "👤 Administrator",
                    job = "Job",
                    label = "Label",
                    name = "Navn",
                    amount = "Beløb",
                    status = "Status",
                    id = "ID",
                    discord = "Discord"
                }
            },
            gradeDeleted = {
                title = "🗑️ Rang Slettet",
                description = "Et job rang er blevet permanent slettet fra systemet",
                fields = {
                    deletedGrade = "🗑️ Slettet Rang",
                    impact = "⚠️ Påvirkning",
                    administrator = "👤 Administrator",
                    job = "Job",
                    grade = "Rang",
                    label = "Label",
                    status = "Status",
                    players = "Spillere",
                    name = "Navn",
                    id = "ID",
                    discord = "Discord"
                }
            },
            common = {
                successfullyCreated = "✅ Oprettet",
                successfullyUpdated = "✅ Opdateret",
                permanentlyDeleted = "❌ Permanent Slettet",
                allDeleted = "Alle Slettet",
                affected = "Påvirket",
                completeDeletion = "Fuld Sletning",
                salaryUpdateOnly = "Kun Løn Opdatering",
                protected = "Beskyttet",
                no = "Nej",
                yes = "Ja"
            }
        },
        ['en'] = {
            jobCreated = {
                title = "🆕 New Job Created",
                description = "A new job has been successfully created in the system",
                fields = {
                    jobInfo = "📋 Job Information",
                    administrator = "👤 Administrator",
                    details = "📊 Details",
                    status = "Status",
                    whitelisted = "Whitelisted",
                    grades = "Grades",
                    job = "Job",
                    label = "Label",
                    name = "Name",
                    id = "ID",
                    discord = "Discord"
                }
            },
            jobDeleted = {
                title = "🗑️ Job Deleted",
                description = "A job and all its grades have been permanently deleted from the system",
                fields = {
                    deletedJob = "🗑️ Deleted Job",
                    administrator = "👤 Administrator",
                    impact = "⚠️ Impact",
                    action = "Action",
                    status = "Status",
                    grades = "Grades",
                    players = "Players",
                    job = "Job",
                    name = "Name",
                    id = "ID",
                    discord = "Discord"
                }
            },
            gradeCreated = {
                title = "⭐ New Grade Created",
                description = "A new job grade has been successfully created",
                fields = {
                    gradeInfo = "⭐ Grade Information",
                    salaryDetails = "💰 Salary Details",
                    administrator = "👤 Administrator",
                    job = "Job",
                    grade = "Grade",
                    label = "Label",
                    amount = "Amount",
                    name = "Name"
                }
            },
            protectedGradeUpdated = {
                title = "💰 Protected Grade Updated",
                description = "Salary updated for protected job grade - other fields locked",
                fields = {
                    protectedJob = "🛡️ Protected Job",
                    newSalary = "💰 New Salary",
                    administrator = "👤 Administrator",
                    job = "Job",
                    action = "Action",
                    amount = "Amount",
                    status = "Status",
                    name = "Name",
                    id = "ID",
                    discord = "Discord"
                }
            },
            gradeUpdated = {
                title = "✏️ Grade Updated",
                description = "A job grade has been successfully updated",
                fields = {
                    gradeInfo = "✏️ Grade Information",
                    salaryDetails = "💰 Salary Details",
                    administrator = "👤 Administrator",
                    job = "Job",
                    label = "Label",
                    name = "Name",
                    amount = "Amount",
                    status = "Status"
                }
            },
            gradeDeleted = {
                title = "🗑️ Grade Deleted",
                description = "A job grade has been permanently deleted from the system",
                fields = {
                    deletedGrade = "🗑️ Deleted Grade",
                    impact = "⚠️ Impact",
                    administrator = "👤 Administrator",
                    job = "Job",
                    grade = "Grade",
                    label = "Label",
                    status = "Status",
                    players = "Players",
                    name = "Name",
                    id = "ID",
                    discord = "Discord"
                }
            },
            common = {
                successfullyCreated = "✅ Successfully Created",
                successfullyUpdated = "✅ Successfully Updated",
                permanentlyDeleted = "❌ Permanently Deleted",
                allDeleted = "All Deleted",
                affected = "Affected",
                completeDeletion = "Complete Deletion",
                salaryUpdateOnly = "Salary Update Only",
                protected = "Protected",
                no = "No",
                yes = "Yes"
            }
        }
    }
    
    return messages[locale] or messages['en']
end

function DiscordLogger.GetPlayerInfo(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return "Unknown", "Unknown", "Unknown" end
    
    local playerName = xPlayer.getName()
    local playerIdentifier = xPlayer.getIdentifier()
    local discordId = "Unknown"
    
    local identifiers = GetPlayerIdentifiers(source)
    if identifiers then
        for _, identifier in pairs(identifiers) do
            if string.sub(identifier, 1, 8) == "discord:" then
                discordId = string.sub(identifier, 9)
                break
            end
        end
    end
    
    return playerName, playerIdentifier, discordId
end

function DiscordLogger.LogJobCreated(source, jobName, jobLabel)
    local playerName, playerIdentifier, discordId = DiscordLogger.GetPlayerInfo(source)
    local messages = DiscordLogger.GetMessages(Config.Locale)
    local fields = {
        {["name"] = messages.jobCreated.fields.jobInfo, ["value"] = "**" .. messages.jobCreated.fields.job .. ":** " .. jobName .. "\n**" .. messages.jobCreated.fields.label .. ":** " .. jobLabel, ["inline"] = true},
        {["name"] = messages.jobCreated.fields.administrator, ["value"] = "**" .. messages.jobCreated.fields.name .. ":** " .. playerName .. "\n**" .. messages.jobCreated.fields.id .. ":** " .. source .. "\n**" .. messages.jobCreated.fields.discord .. ":** <@" .. discordId .. ">", ["inline"] = true},
        {["name"] = messages.jobCreated.fields.details, ["value"] = "**" .. messages.jobCreated.fields.status .. ":** " .. messages.common.successfullyCreated .. "\n**" .. messages.jobCreated.fields.whitelisted .. ":** " .. messages.common.no .. "\n**" .. messages.jobCreated.fields.grades .. ":** 0", ["inline"] = true}
    }
    DiscordLogger.SendLog(Config.Discord.webhooks.createJob, messages.jobCreated.title, messages.jobCreated.description, Config.Discord.colors.create, fields)
end

function DiscordLogger.LogJobDeleted(source, jobName)
    local playerName, playerIdentifier, discordId = DiscordLogger.GetPlayerInfo(source)
    local messages = DiscordLogger.GetMessages(Config.Locale)
    local fields = {
        {["name"] = messages.jobDeleted.fields.deletedJob, ["value"] = "**" .. messages.jobDeleted.fields.job .. ":** " .. jobName .. "\n**" .. messages.jobDeleted.fields.action .. ":** " .. messages.common.completeDeletion, ["inline"] = true},
        {["name"] = messages.jobDeleted.fields.administrator, ["value"] = "**" .. messages.jobDeleted.fields.name .. ":** " .. playerName .. "\n**" .. messages.jobDeleted.fields.id .. ":** " .. source .. "\n**" .. messages.jobDeleted.fields.discord .. ":** <@" .. discordId .. ">", ["inline"] = true},
        {["name"] = messages.jobDeleted.fields.impact, ["value"] = "**" .. messages.jobDeleted.fields.status .. ":** " .. messages.common.permanentlyDeleted .. "\n**" .. messages.jobDeleted.fields.grades .. ":** " .. messages.common.allDeleted .. "\n**" .. messages.jobDeleted.fields.players .. ":** " .. messages.common.affected, ["inline"] = true}
    }
    DiscordLogger.SendLog(Config.Discord.webhooks.deleteJob, messages.jobDeleted.title, messages.jobDeleted.description, Config.Discord.colors.delete, fields)
end

function DiscordLogger.LogGradeCreated(source, jobName, grade, name, label, salary)
    local playerName, playerIdentifier, discordId = DiscordLogger.GetPlayerInfo(source)
    local messages = DiscordLogger.GetMessages(Config.Locale)
    local currencyPrefix = Config.Currency.prefix or '$'
    local currencySuffix = Config.Currency.suffix or ''
    local currencyPosition = Config.Currency.position or 'before'
    local salaryDisplay = currencyPosition == 'after' and salary .. currencyPrefix .. currencySuffix or currencyPrefix .. salary .. currencySuffix
    
    local fields = {
        {["name"] = messages.gradeCreated.fields.gradeInfo, ["value"] = "**" .. messages.gradeCreated.fields.job .. ":** " .. jobName .. "\n**" .. messages.gradeCreated.fields.grade .. ":** " .. grade .. "\n**" .. messages.gradeCreated.fields.label .. ":** " .. label, ["inline"] = true},
        {["name"] = messages.gradeCreated.fields.salaryDetails, ["value"] = "**" .. messages.gradeCreated.fields.amount .. ":** " .. salaryDisplay .. "\n**" .. messages.gradeCreated.fields.name .. ":** " .. name, ["inline"] = true},
        {["name"] = messages.gradeCreated.fields.administrator, ["value"] = "**" .. messages.gradeCreated.fields.name .. ":** " .. playerName .. "\n**" .. messages.gradeCreated.fields.id .. ":** " .. source .. "\n**" .. messages.gradeCreated.fields.discord .. ":** <@" .. discordId .. ">", ["inline"] = true}
    }
    DiscordLogger.SendLog(Config.Discord.webhooks.createGrade, messages.gradeCreated.title, messages.gradeCreated.description, Config.Discord.colors.create, fields)
end

function DiscordLogger.LogProtectedGradeUpdated(source, jobName, salary)
    local playerName, playerIdentifier, discordId = DiscordLogger.GetPlayerInfo(source)
    local messages = DiscordLogger.GetMessages(Config.Locale)
    local currencyPrefix = Config.Currency.prefix or '$'
    local currencySuffix = Config.Currency.suffix or ''
    local currencyPosition = Config.Currency.position or 'before'
    local salaryDisplay = currencyPosition == 'after' and salary .. currencyPrefix .. currencySuffix or currencyPrefix .. salary .. currencySuffix
    
    local fields = {
        {["name"] = messages.protectedGradeUpdated.fields.protectedJob, ["value"] = "**" .. messages.protectedGradeUpdated.fields.job .. ":** " .. jobName .. " (" .. messages.common.protected .. ")\n**" .. messages.protectedGradeUpdated.fields.action .. ":** " .. messages.common.salaryUpdateOnly, ["inline"] = true},
        {["name"] = messages.protectedGradeUpdated.fields.newSalary, ["value"] = "**" .. messages.protectedGradeUpdated.fields.amount .. ":** " .. salaryDisplay .. "\n**" .. messages.protectedGradeUpdated.fields.status .. ":** " .. messages.common.successfullyUpdated, ["inline"] = true},
        {["name"] = messages.protectedGradeUpdated.fields.administrator, ["value"] = "**" .. messages.protectedGradeUpdated.fields.name .. ":** " .. playerName .. "\n**" .. messages.protectedGradeUpdated.fields.id .. ":** " .. source .. "\n**" .. messages.protectedGradeUpdated.fields.discord .. ":** <@" .. discordId .. ">", ["inline"] = true}
    }
    DiscordLogger.SendLog(Config.Discord.webhooks.updateGrade, messages.protectedGradeUpdated.title, messages.protectedGradeUpdated.description, Config.Discord.colors.update, fields)
end

function DiscordLogger.LogGradeUpdated(source, jobName, name, label, salary)
    local playerName, playerIdentifier, discordId = DiscordLogger.GetPlayerInfo(source)
    local messages = DiscordLogger.GetMessages(Config.Locale)
    local currencyPrefix = Config.Currency.prefix or '$'
    local currencySuffix = Config.Currency.suffix or ''
    local currencyPosition = Config.Currency.position or 'before'
    local salaryDisplay = currencyPosition == 'after' and salary .. currencyPrefix .. currencySuffix or currencyPrefix .. salary .. currencySuffix
    
    local fields = {
        {["name"] = messages.gradeUpdated.fields.gradeInfo, ["value"] = "**" .. messages.gradeUpdated.fields.job .. ":** " .. jobName .. "\n**" .. messages.gradeUpdated.fields.label .. ":** " .. label .. "\n**" .. messages.gradeUpdated.fields.name .. ":** " .. name, ["inline"] = true},
        {["name"] = messages.gradeUpdated.fields.salaryDetails, ["value"] = "**" .. messages.gradeUpdated.fields.amount .. ":** " .. salaryDisplay .. "\n**" .. messages.gradeUpdated.fields.status .. ":** " .. messages.common.successfullyUpdated, ["inline"] = true},
        {["name"] = messages.gradeUpdated.fields.administrator, ["value"] = "**" .. messages.gradeUpdated.fields.name .. ":** " .. playerName .. "\n**" .. messages.gradeUpdated.fields.id .. ":** " .. source .. "\n**" .. messages.gradeUpdated.fields.discord .. ":** <@" .. discordId .. ">", ["inline"] = true}
    }
    DiscordLogger.SendLog(Config.Discord.webhooks.updateGrade, messages.gradeUpdated.title, messages.gradeUpdated.description, Config.Discord.colors.update, fields)
end

function DiscordLogger.LogGradeDeleted(source, jobName, label, grade)
    local playerName, playerIdentifier, discordId = DiscordLogger.GetPlayerInfo(source)
    local messages = DiscordLogger.GetMessages(Config.Locale)
    local fields = {
        {["name"] = messages.gradeDeleted.fields.deletedGrade, ["value"] = "**" .. messages.gradeDeleted.fields.job .. ":** " .. jobName .. "\n**" .. messages.gradeDeleted.fields.grade .. ":** " .. grade .. "\n**" .. messages.gradeDeleted.fields.label .. ":** " .. label, ["inline"] = true},
        {["name"] = messages.gradeDeleted.fields.impact, ["value"] = "**" .. messages.gradeDeleted.fields.status .. ":** " .. messages.common.permanentlyDeleted .. "\n**" .. messages.gradeDeleted.fields.players .. ":** " .. messages.common.affected, ["inline"] = true},
        {["name"] = messages.gradeDeleted.fields.administrator, ["value"] = "**" .. messages.gradeDeleted.fields.name .. ":** " .. playerName .. "\n**" .. messages.gradeDeleted.fields.id .. ":** " .. source .. "\n**" .. messages.gradeDeleted.fields.discord .. ":** <@" .. discordId .. ">", ["inline"] = true}
    }
    DiscordLogger.SendLog(Config.Discord.webhooks.deleteGrade, messages.gradeDeleted.title, messages.gradeDeleted.description, Config.Discord.colors.delete, fields)
end

