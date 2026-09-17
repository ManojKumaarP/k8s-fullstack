const BACKEND_URL = "http://localhost:8080";

async function loadEmployees() {

    const response = await fetch(
        `${BACKEND_URL}/api/employees`
    );

    const employees = await response.json();

    const table = document.getElementById("employeeTable");

    table.innerHTML = "";

    employees.forEach(employee => {

        const row = `
            <tr>
                <td>${employee.id}</td>
                <td>${employee.name}</td>
                <td>${employee.role}</td>
                <td>${employee.department}</td>
            </tr>
        `;

        table.innerHTML += row;
    });
}