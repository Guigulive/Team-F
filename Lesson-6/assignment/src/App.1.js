import React,{Component} from 'react'
import PayrollContract from '../build/contracts/Payroll.json'
import getweb3 from './utils/getWeb3'

//Accounts 账号列表
import Accounts from './components/Accounts'
//Employer 老板
import Employer from './components/Employer'
//Employee 马仔
import Employee from './components/Employee'
//Common 通用信息
import Common  from './components/Common'

import './css/oswald.css'
import './css/open-sans.css'
import './css/pure-min.css'
// import './css/App.css'

class App extends Component {
    constructor(props){
        super(props)

        this.state = {
            web3:null
        }
    }

    componentWillMount(){

        getweb3
        .then(results => {
            this.setState({
                web3:results.web3
            })

            this.instantiateContract() 
        })
        .catch(() => {
            console.log('Error finding web3.')
        })
    }



    instantiateContract(){
        const contract = require('truffle-contract')
        const Payroll = contract(PayrollContract)
        Payroll.setProvider(this.state.web3.currentProvider)

        // var PayrollInstance

        this.state.web3.eth.getAccounts((error,accounts) => {
            this.setState({
                accounts,
                selectedAccount:accounts[0]
            });
            Payroll.deployed().then((instance) => {
                // PayrollInstance = instance
                this.setState({
                    payroll:instance
                })
            })

        })

    }

    onSelectAccount = (ev) => {
        this.setState({
            selectedAccount:ev.target.text
        })
    }

    render(){
        const {selectedAccount,accounts,payroll,web3} = this.state

        // console.log(selectedAccount,accounts,payroll,web3)

        if (!accounts){
            return <div>Loading</div>
        }

        return(
            <div className="App">
                <nav className="navbar pure-menu pure-menu-horizontal">
                    <a href="#" className="pure-menu-heading pure-menu-link">Payroll</a>
                </nav>

                <main className="container">
                    <div className="pure-g">   
                        <div className="pure-u-1-3">
                            <Accounts accounts={accounts} onSelectAccount={this.onSelectAccount} />
                        </div>
                        <div className="pure-u-2-3">
                        {/* {console.log("App.js selectedAccount:",selectedAccount)} */}
                        {
                            selectedAccount === accounts[0] ?
                                <Employer employer={selectedAccount} payroll={payroll} web3={web3} />
                            :
                                <Employee employee={selectedAccount} payroll={payroll} web3={web3} />  

                        }
                        {payroll && <Common account={selectedAccount} payroll={payroll} web3={web3} />}    
                        </div>
                    </div>
                </main>
            </div>  

        )

    }

}


export default App
