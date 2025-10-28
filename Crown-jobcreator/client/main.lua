local ESX = exports["es_extended"]:getSharedObject()
local currentJobs = {}

function OpenJobCreatorMenu()
    ESX.TriggerServerCallback('crown-jobcreator:getJobs', function(jobs)
        currentJobs = jobs
        
        OpenReactUI()
    end)
end

function OpenReactUI()
    SetNuiFocus(true, true)
    
    SendNUIMessage({
        type = 'openUI',
        jobs = currentJobs,
        colors = Config.UIColors,
        locale = Config.Locale,
        protectedJobs = Config.ProtectedJobs,
        salaryLimits = Config.SalaryLimits,
        gradeLimits = Config.GradeLimits,
        currency = Config.Currency
    })
end

function CloseReactUI()
    SetNuiFocus(false, false)
end

RegisterNetEvent('crown-jobcreator:refreshJobs')
AddEventHandler('crown-jobcreator:refreshJobs', function()
    ESX.TriggerServerCallback('crown-jobcreator:getJobs', function(jobs)
        currentJobs = jobs
        SendNUIMessage({
            type = 'refreshJobs',
            jobs = jobs
        })
    end)
end)

RegisterNetEvent('crown-jobcreator:refreshJobGrades')
AddEventHandler('crown-jobcreator:refreshJobGrades', function(jobName)
    SendNUIMessage({
        type = 'refreshJobGrades',
        jobName = jobName
    })
end)

RegisterNUICallback('closeUI', function(data, cb)
    CloseReactUI()
    cb('ok')
end)

local function CreateSimpleCallback(eventName, dataTransform)
    return function(data, cb)
        TriggerServerEvent(eventName, dataTransform and dataTransform(data) or data)
        cb('ok')
    end
end

RegisterNUICallback('createJob', CreateSimpleCallback('crown-jobcreator:createJob'))
RegisterNUICallback('updateJob', CreateSimpleCallback('crown-jobcreator:updateJob'))
RegisterNUICallback('deleteJob', CreateSimpleCallback('crown-jobcreator:deleteJob', function(data) return data.jobName end))

RegisterNUICallback('getJobGrades', function(data, cb)
    ESX.TriggerServerCallback('crown-jobcreator:getJobGrades', function(grades)
        cb(grades)
    end, data.jobName)
end)

RegisterNUICallback('createJobGrade', CreateSimpleCallback('crown-jobcreator:createJobGrade'))
RegisterNUICallback('updateJobGrade', CreateSimpleCallback('crown-jobcreator:updateJobGrade'))
RegisterNUICallback('deleteJobGrade', CreateSimpleCallback('crown-jobcreator:deleteJobGrade', function(data) return data.gradeId end))

RegisterKeyMapping('jobcreator', 'Open Job Creator Menu', 'keyboard', 'F5')

RegisterCommand('jobcreator', function()
    OpenJobCreatorMenu()
end, false)
