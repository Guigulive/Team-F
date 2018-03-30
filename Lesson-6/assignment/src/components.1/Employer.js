import React,{Component} from 'react'

class Emploer extends Component {
    constructor(props){
        super(props)
        this.state={}
    }

    addFund =() => {
        const {payroll,employer,web3} = this.props
        payroll.addFund({from:employer,value:web3.toWei(this.fundInput.value)})
    }

    addEmployee = () =>{
        const {payroll,employer} = this.props
        
        payroll.addEmployee(this.employeeInput.value,parseInt(this.salaryInput.value,10),{from:employer,gas:1000000}).then((result) => {alert('success')})
    }

    updateEmployee = () => {
        const {payroll,employer} = this.props
        console.log(employer,this.employeeInput.value,this.salaryInput.value)
        payroll.updateEmployee(this.employeeInput.value,parseInt(this.salaryInput.value,10),{from:employer,gas:1000000}).then((result) => {alert('success')})
    }

    removeEmployee = () => {
        const {payroll,employer} = this.props
        payroll.removeEmployee(this.removeEmployeeInput.value,{from:employer,gas:1000000}).then((result) => {alert('success')})
    }

    render(){
        return(
            <div>
                <h2>Emploer</h2>
                <form className="pure-form pure-form-stacked">
                    <fieldset>
                        <legend>Add fund</legend>
                        <label>fund</label>
                        <input type="text" placeholder="请输入要增加的fund" ref={(input) => {this.fundInput = input}} />
                        <button type="button" className="pure-button" onClick={this.addFund} >增加点数</button>
                    </fieldset>
                </form>

                <form className="pure-form pure-form-stacked">
                    <fieldset>
                        <legend>增加/修改员工工资</legend>
                        <label>账户地址</label>
                        <input type="text" placeholder="请输入账户的Address" ref={(input) => {this.employeeInput = input}} />
                        <label>工资</label>
                        <input type="text" placeholder="请输入金额" ref={(input) => {this.salaryInput = input}} />
                        <button type="button" className="pure-button" onClick={this.addEmployee}  >增加员工</button>
                        <button type="button" className="pure-button" onClick={this.updateEmployee} >修改员工工资</button>
                    </fieldset>
                </form>

                <form className="pure-form pure-form-stacked">
                    <fieldset>
                        <legend>删除员工</legend>
                        <label>账户地址</label>
                        <input type="text" placeholder="请输入账户的Address" ref={(input) => {this.removeEmployeeInput = input}} />
                        <button type="button" className="pure-button" onClick={this.removeEmployee}  >删除员工</button>
                    </fieldset>
                </form>
            </div>
        )
    }


}

export default Emploer