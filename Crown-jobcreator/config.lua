Config = {}
Config.Locale = 'en' -- EN / DA

-- ========================================
-- PERMISSIONS & PROTECTED JOBS
-- ========================================

Config.AdminGroups = {
    'admin',
}

Config.ProtectedJobs = {
    'unemployed',
    'police',
    'ambulance',
}

-- ========================================
-- DATABASE SETTINGS
-- ========================================

Config.Database = {
    jobsTable = 'jobs',
    jobGradesTable = 'job_grades'
}

-- ========================================
-- SALARY & GRADE LIMITS
-- ========================================

Config.SalaryLimits = {
    min = 0,
    max = 20000
}

Config.GradeLimits = {
    min = 0,
    max = 10
}

-- ========================================
-- COLORS & CURRENCY
-- ========================================

Config.UIColors = {
    primary = '#FFA500', -- Orange 
}

Config.Currency = {
    prefix = '$',
    suffix = '',
    position = 'before' -- Before / After
}

-- ========================================
-- DISCORD LOGS
-- ========================================

Config.Discord = {
    enabled = true,
    webhooks = {
        createJob = 'YOUR_CREATE_JOB_WEBHOOK_URL',
        deleteJob = 'YOUR_DELETE_JOB_WEBHOOK_URL',
        createGrade = 'YOUR_CREATE_GRADE_WEBHOOK_URL',
        updateGrade = 'YOUR_UPDATE_GRADE_WEBHOOK_URL',
        deleteGrade = 'YOUR_DELETE_GRADE_WEBHOOK_URL',
    },
    botName = 'Job Creator',
    botAvatar = 'https://i.imgur.com/ZTluCz6.png',
    colors = {
        create = 0x00ff00,
        update = 0xffaa00,
        delete = 0xff0000,
    }
}
