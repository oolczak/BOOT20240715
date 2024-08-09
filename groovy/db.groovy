import groovy.sql.Sql

def url = 'jdbc:oracle:thin:@localhost:1521:xe'
def user = 'alumno'
def password = 'alumno'
def driver = 'oracle.jdbc.driver.OracleDriver'
def sql = Sql.newInstance(url, user, password, driver)

def rowNum = 0
sql.query('''
  SELECT *
  FROM   EMPLOYEES
  ORDER BY EMPLOYEE_ID
  FETCH NEXT 10 ROWS ONLY
''') { resultSet ->
  while (resultSet.next()) {
    def id = resultSet.getString(1)
    def first = resultSet.getString('first_name')
    def last = resultSet.getString('last_name')
    println "${++rowNum} $id $first $last"
  }
}
sql.close()
