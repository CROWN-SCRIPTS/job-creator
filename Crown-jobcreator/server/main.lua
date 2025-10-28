ESX = exports["es_extended"]:getSharedObject()

local function SendNotification(source, type, title, description)
    TriggerClientEvent('ox_lib:notify', source, {
        title = title,
        description = description,
        type = type
    })
end

local function IsPlayerAdmin(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return false end
    
    for _, group in ipairs(Config.AdminGroups) do
        if xPlayer.getGroup() == group then
            return true
        end
    end
    return false
end

local function CheckAdminAccess(source)
    if not IsPlayerAdmin(source) then
        SendNotification(source, 'error', 'Fejl', 'Du har ikke tilladelse til at udføre denne handling')
        return false
    end
    return true
end

ESX.RegisterServerCallback('crown-jobcreator:getJobs', function(source, cb)
    if not IsPlayerAdmin(source) then
        cb('Du har ikke tilladelse til at bruge denne menu')
        return
    end
    
    exports.oxmysql:execute('SELECT * FROM ' .. Config.Database.jobsTable, {}, function(result)
        cb(result)
    end)
end)

ESX.RegisterServerCallback('crown-jobcreator:getJobGrades', function(source, cb, jobName)
    if not IsPlayerAdmin(source) then
        cb('Du har ikke tilladelse til at bruge denne menu')
        return
    end
    
    exports.oxmysql:execute('SELECT * FROM ' .. Config.Database.jobGradesTable .. ' WHERE job_name = ? ORDER BY grade ASC', {jobName}, function(result)
        cb(result)
    end)
end)

RegisterNetEvent('crown-jobcreator:createJob')
AddEventHandler('crown-jobcreator:createJob', function(jobData)
    local source = source
    if not IsPlayerAdmin(source) then
        SendNotification(source, 'error', 'Fejl', 'Du har ikke tilladelse til at udføre denne handling')
        return
    end
    
    local jobName = jobData.name
    local jobLabel = jobData.label
    
    if not jobName or jobName == '' or not jobLabel or jobLabel == '' then
        SendNotification(source, 'error', 'Fejl', 'Job navn og label skal udfyldes')
        return
    end
    
    exports.oxmysql:execute('SELECT name FROM ' .. Config.Database.jobsTable .. ' WHERE name = ?', {jobName}, function(result)
        if #result > 0 then
            SendNotification(source, 'error', 'Fejl', 'Et job med dette navn eksisterer allerede')
            return
        end
        
        exports.oxmysql:execute('INSERT INTO ' .. Config.Database.jobsTable .. ' (name, label, whitelisted) VALUES (?, ?, ?)', {
            jobName, jobLabel, false
        }, function(result)
            if result and result.insertId then
                SendNotification(source, 'success', 'Succes', 'Job "' .. jobLabel .. '" blev oprettet')
                
                DiscordLogger.LogJobCreated(source, jobName, jobLabel)
                TriggerClientEvent('crown-jobcreator:refreshJobs', source)
            else
                SendNotification(source, 'error', 'Fejl', 'Kunne ikke oprette job')
            end
        end)
    end)
end)

RegisterNetEvent('crown-jobcreator:updateJob')
AddEventHandler('crown-jobcreator:updateJob', function(jobData)
    local source = source
    if not CheckAdminAccess(source) then return end
    
    local jobName = jobData.name
    local jobLabel = jobData.label
    
    if not jobName or jobName == '' or not jobLabel or jobLabel == '' then
        SendNotification(source, 'error', 'Fejl', 'Job navn og label skal udfyldes')
        return
    end
    
    exports.oxmysql:execute('UPDATE ' .. Config.Database.jobsTable .. ' SET label = ? WHERE name = ?', {
        jobLabel, jobName
    }, function(result)
        if result then
            SendNotification(source, 'success', 'Succes', 'Job "' .. jobLabel .. '" blev opdateret')
            TriggerClientEvent('crown-jobcreator:refreshJobs', source)
        else
            SendNotification(source, 'error', 'Fejl', 'Kunne ikke opdatere job')
        end
    end)
end)

RegisterNetEvent('crown-jobcreator:deleteJob')
AddEventHandler('crown-jobcreator:deleteJob', function(jobName)
    local source = source
    if not CheckAdminAccess(source) then return end
    
    if not jobName or jobName == '' then
        SendNotification(source, 'error', 'Fejl', 'Job navn skal udfyldes')
        return
    end
    
    exports.oxmysql:execute('DELETE FROM ' .. Config.Database.jobGradesTable .. ' WHERE job_name = ?', {jobName}, function()
        exports.oxmysql:execute('DELETE FROM ' .. Config.Database.jobsTable .. ' WHERE name = ?', {jobName}, function(result)
            if result then
                SendNotification(source, 'success', 'Succes', 'Job "' .. jobName .. '" og alle ranks blev slettet')
                
                DiscordLogger.LogJobDeleted(source, jobName)
                TriggerClientEvent('crown-jobcreator:refreshJobs', source)
            else
                SendNotification(source, 'error', 'Fejl', 'Kunne ikke slette job')
            end
        end)
    end)
end)

RegisterNetEvent('crown-jobcreator:createJobGrade')
AddEventHandler('crown-jobcreator:createJobGrade', function(gradeData)
    local source = source
    if not CheckAdminAccess(source) then return end
    
    local jobName = gradeData.job_name
    local grade = gradeData.grade
    local name = gradeData.name
    local label = gradeData.label
    local salary = gradeData.salary
    
    for _, protectedJob in ipairs(Config.ProtectedJobs) do
        if string.lower(jobName) == string.lower(protectedJob) then
            SendNotification(source, 'error', 'Fejl', 'Du kan ikke tilføje ranks til ' .. protectedJob .. ' job')
            return
        end
    end
    
    if not jobName or jobName == '' or not name or name == '' or not label or label == '' then
        SendNotification(source, 'error', 'Fejl', 'Alle felter skal udfyldes')
        return
    end
    
    if grade < Config.GradeLimits.min or grade > Config.GradeLimits.max then
        SendNotification(source, 'error', 'Fejl', 'Grade skal være mellem ' .. Config.GradeLimits.min .. ' og ' .. Config.GradeLimits.max)
        return
    end
    
    if salary < Config.SalaryLimits.min or salary > Config.SalaryLimits.max then
        SendNotification(source, 'error', 'Fejl', 'Løn skal være mellem ' .. Config.SalaryLimits.min .. ' og ' .. Config.SalaryLimits.max)
        return
    end
    
    exports.oxmysql:execute('SELECT id FROM ' .. Config.Database.jobGradesTable .. ' WHERE job_name = ? AND grade = ?', {
        jobName, grade
    }, function(result)
        if #result > 0 then
            SendNotification(source, 'error', 'Fejl', 'En rank med denne grade eksisterer allerede for dette job')
            return
        end
        
        exports.oxmysql:execute('INSERT INTO ' .. Config.Database.jobGradesTable .. ' (job_name, grade, name, label, salary) VALUES (?, ?, ?, ?, ?)', {
            jobName, grade, name, label, salary
        }, function(result)
            if result and result.insertId then
                SendNotification(source, 'success', 'Succes', 'Rank "' .. label .. '" blev oprettet')
                
                DiscordLogger.LogGradeCreated(source, jobName, grade, name, label, salary)
                TriggerClientEvent('crown-jobcreator:refreshJobGrades', source, jobName)
            else
                SendNotification(source, 'error', 'Fejl', 'Kunne ikke oprette rank')
            end
        end)
    end)
end)

RegisterNetEvent('crown-jobcreator:updateJobGrade')
AddEventHandler('crown-jobcreator:updateJobGrade', function(gradeData)
    local source = source
    if not CheckAdminAccess(source) then return end
    
    local id = gradeData.id
    local name = gradeData.name
    local label = gradeData.label
    local salary = gradeData.salary
    
    exports.oxmysql:execute('SELECT job_name FROM ' .. Config.Database.jobGradesTable .. ' WHERE id = ?', {
        id
    }, function(result)
        if #result == 0 then
            SendNotification(source, 'error', 'Fejl', 'Rank ikke fundet')
            return
        end
        
        local jobName = result[1].job_name
        
        local isProtected = false
        for _, protectedJob in ipairs(Config.ProtectedJobs) do
            if string.lower(jobName) == string.lower(protectedJob) then
                isProtected = true
                break
            end
        end
        
        if isProtected then
            exports.oxmysql:execute('UPDATE ' .. Config.Database.jobGradesTable .. ' SET salary = ? WHERE id = ?', {
                salary, id
            }, function(result)
                if result then
                    SendNotification(source, 'success', 'Succes', 'Løn blev opdateret for ' .. jobName .. ' rank')
                    
                    DiscordLogger.LogProtectedGradeUpdated(source, jobName, salary)
                    TriggerClientEvent('crown-jobcreator:refreshJobGrades', source, jobName)
                else
                    SendNotification(source, 'error', 'Fejl', 'Kunne ikke opdatere løn')
                end
            end)
            return
        end
        
        if not name or name == '' or not label or label == '' then
            TriggerClientEvent('ox_lib:notify', source, {
                title = 'Fejl',
                description = 'Alle felter skal udfyldes',
                type = 'error'
            })
            return
        end
        
        if salary < Config.SalaryLimits.min or salary > Config.SalaryLimits.max then
            TriggerClientEvent('ox_lib:notify', source, {
                title = 'Fejl',
                description = 'Løn skal være mellem ' .. Config.SalaryLimits.min .. ' og ' .. Config.SalaryLimits.max,
                type = 'error'
            })
            return
        end
        
        exports.oxmysql:execute('UPDATE ' .. Config.Database.jobGradesTable .. ' SET name = ?, label = ?, salary = ? WHERE id = ?', {
            name, label, salary, id
        }, function(result)
            if result then
                SendNotification(source, 'success', 'Succes', 'Rank "' .. label .. '" blev opdateret')
                
                DiscordLogger.LogGradeUpdated(source, jobName, name, label, salary)
                TriggerClientEvent('crown-jobcreator:refreshJobGrades', source, jobName)
            else
                SendNotification(source, 'error', 'Fejl', 'Kunne ikke opdatere rank')
            end
        end)
    end)
end)

RegisterNetEvent('crown-jobcreator:deleteJobGrade')
AddEventHandler('crown-jobcreator:deleteJobGrade', function(gradeId)
    local source = source
    if not CheckAdminAccess(source) then return end
    
    if not gradeId then
        SendNotification(source, 'error', 'Fejl', 'Rank ID skal udfyldes')
        return
    end
    
    exports.oxmysql:execute('SELECT job_name, label, grade FROM ' .. Config.Database.jobGradesTable .. ' WHERE id = ?', {
        gradeId
    }, function(result)
        if #result == 0 then
            SendNotification(source, 'error', 'Fejl', 'Rank ikke fundet')
            return
        end
        
        local jobName = result[1].job_name
        local label = result[1].label
        local grade = result[1].grade
        
        for _, protectedJob in ipairs(Config.ProtectedJobs) do
            if string.lower(jobName) == string.lower(protectedJob) then
                SendNotification(source, 'error', 'Fejl', 'Du kan ikke slette ' .. protectedJob .. ' ranks')
                return
            end
        end
        
        exports.oxmysql:execute('DELETE FROM ' .. Config.Database.jobGradesTable .. ' WHERE id = ?', {
            gradeId
        }, function(result)
            if result then
                SendNotification(source, 'success', 'Succes', 'Rank "' .. label .. '" blev slettet')
                
                DiscordLogger.LogGradeDeleted(source, jobName, label, grade)
                TriggerClientEvent('crown-jobcreator:refreshJobGrades', source, jobName)
            else
                SendNotification(source, 'error', 'Fejl', 'Kunne ikke slette rank')
            end
        end)
    end)
end)
