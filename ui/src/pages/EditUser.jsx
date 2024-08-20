import { useRef } from "react"
import {  deleteUser, downloadData, editUser } from "../lib/api"
import { useNavigate } from "react-router-dom";

export default function EditUser() {
    let navigate = useNavigate();
    const formele = useRef()
    const handleEditUser = async (e) => {
        e.preventDefault()
        const res = await editUser(new FormData(formele.current))
        if (res[0] === true) {
            navigate("/home")
            return
        }
        if(Array.isArray(res[1])){
            res[1].error.forEach(error => {
                toast.error(error)
            });
            return 
        }
        toast.error(res[1].error)
    }

    const handleDeleteUser = async ()=>{
        const res = await deleteUser()
            if (res[0] === true) {
                toast.success("user deleted")
                navigate('/login')
                return
            }
            if(Array.isArray(res[1])){
                res[1].error.forEach(error => {
                    toast.error(error)
                });
                return 
            }
            toast.error(res[1].error)
    }

    const handleDownloadData = async ()=>{
        const res = await downloadData()
            if (res[0] === true) {
                toast.success("Data send to email")
                return
            }
            if(Array.isArray(res[1])){
                res[1].error.forEach(error => {
                    toast.error(error)
                });
                return 
            }
            toast.error(res[1].error)
    }

    return (<div className="flex flex-col  gap-[10px] items-center mx-auto">
        <h2 className="mt-[50px] font-bold text-center">Edit User</h2>
        <form onSubmit={handleEditUser} ref={formele}>
            <label className="form-control w-full max-w-xs  ">

                <div className="mt-[50px]">
                    <div>
                        <div className="label">
                            <span className="label-text">First name</span>
                        </div>
                        <input name="first_name" type="text" placeholder="Type here" className="input input-bordered w-full max-w-xs" />
                    </div>
                    <div>
                        <div className="label">
                            <span className="label-text">Last name</span>
                        </div>
                        <input name="last_name" type="text" placeholder="Type here" className="input input-bordered w-full max-w-xs" />
                    </div>

                    <div className="mt-[10px]">
                        <div className="label">
                            <span className="label-text">Bio</span>
                        </div>
                        <textarea name="bio" className="w-full input-bordered  textarea textarea-ghost" ></textarea>
                    </div>
                    <label className="form-control w-full max-w-xs">
                        <div className="label">
                            <span className="text-white label-text">Avatar</span>
                        </div>
                        <input multiple type="file" name="avatar" className="file-input file-input-bordered w-full max-w-xs" />
                    </label>
                </div>
            </label>

            <div className=" flex-auto ">
                <button type="submit" className=" rounded-md mt-[40px] btn bg-green-500">Update</button>
            </div>
        </form>
        <div className="flex gap-[10px]">
            <button onClick={handleDeleteUser} className="btn bg-red-400">Delete account</button>
            <button onClick={handleDownloadData} className="btn ">Download Data</button>
        </div>
    </div>)

}