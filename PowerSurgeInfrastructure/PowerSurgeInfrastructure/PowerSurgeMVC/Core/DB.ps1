function Invoke-SQL {
    param(
        [string] $sqlCommand = $(throw "Please specify a query.")
      )

    $connection = New-Object system.data.SqlClient.SQLConnection($AppConfig.DBConnectionString)
    $command = New-Object system.data.sqlclient.sqlcommand($sqlCommand,$connection)
    $connection.Open()

    $adapter = New-Object System.Data.sqlclient.sqlDataAdapter $command
    $dataset = New-Object System.Data.DataSet
    $adapter.Fill($dataSet) | Out-Null

    $connection.Close()
    return $dataSet.Tables

}