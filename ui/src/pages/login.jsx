import {useState} from 'react'
import { logIn } from '../lib/api'
import { useNavigate } from "react-router-dom";
import toast from 'react-hot-toast';

export default function Login(){
    let navigate = useNavigate();
    const [formData , setFormData] = useState({})

    const handleLogIn =async (e)=>{
        e.preventDefault()
        const res = await logIn(formData)
        if(res[0] == true){
            navigate("/home");
            return
        }

        if(Array.isArray(res[1])){
            res[1].error.forEach(error => {
                toast.error(error)
            });
            return 
        }
        toast.error(res[1].error)
        // console.log(logIn(formData))
    }

    return (<section class="bg-gray-50 dark:bg-gray-900">
        <div class="flex flex-col items-center justify-center px-6 py-8 mx-auto md:h-screen lg:py-0">
            
            <div class="w-full bg-white rounded-lg shadow dark:border md:mt-0 sm:max-w-md xl:p-0 dark:bg-gray-800 dark:border-gray-700">
                <div class="p-6 space-y-4 md:space-y-6 sm:p-8">
                    <h1 class="text-xl font-bold leading-tight tracking-tight text-gray-900 md:text-2xl dark:text-white">
                        Login
                    </h1>
                    <form class="space-y-4 md:space-y-6" onSubmit={handleLogIn}>
                        <div>
                            <label for="username" class="block mb-2 text-sm font-medium text-gray-900 dark:text-white">Username</label>
                            <input value={formData.username} onChange={e => setFormData(p => ({...p,username:e.target.value})) } type="text" name="username" id="username" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"  required=""/>
                        </div>
                        <div>
                            <label for="password" class="block mb-2 text-sm font-medium text-gray-900 dark:text-white">Password</label>
                            <input value={formData.password} onChange={e => setFormData(p => ({...p,password:e.target.value})) } type="password" name="password" id="password" placeholder="••••••••" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500" required=""/>
                        </div>
                        <button type="submit" class="w-full text-white bg-primary-600 hover:bg-primary-700 focus:ring-4 focus:outline-none focus:ring-primary-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-primary-600 dark:hover:bg-primary-700 dark:focus:ring-primary-800">Login</button>
                       
                    </form>
                </div>
            </div>
        </div>
      </section>)

}